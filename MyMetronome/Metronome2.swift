//
//  Metronome2.swift
//  MyMetronome
//
//  Created by Michael Vartanian on 8/6/19.
//  Copyright © 2019 Michael Vartanian. All rights reserved.
//

import Foundation
import AVFoundation
import os


public protocol MetronomeDelegate: class {
    func metronomeTicking(_ metronome2: Metronome2, currentTick: Int)
}

public final class Metronome2 {
    
    struct Constants {
        static let kBipDurationSeconds = 0.02
        static let kTempoChangeResponsivenessSeconds = 0.25
        static let kDivisions = [2, 4, 8, 16]
    }

    
    struct MeterConfig{
        static let min = 2
        static let `default` = 4
        static let max = 8
    }
    
    struct TempoConfig{
        static let min = 30
        static let `default` = 120
        static let max = 300
    }
    
    public var meter = 0
    public private(set) var division = 0
    public private(set) var tempoBPM = 0
    public var beatNumber  = 0
    public private(set) var isPlaying = false
    
    public weak var delegate: MetronomeDelegate?
    
    let engine: AVAudioEngine = AVAudioEngine()
    /// owned by engine
    let player: AVAudioPlayerNode = AVAudioPlayerNode()
    
    // Variables/constants needed to incorporate an audio file
    var audioFile_hi : AVAudioFile = AVAudioFile()
    var audioFile_low : AVAudioFile = AVAudioFile()
    var songLengthSamples_hi: AVAudioFramePosition = AVAudioFramePosition()
    var songLengthSamples_low: AVAudioFramePosition = AVAudioFramePosition()

    var sampleRateSong: Float = 0
    var lengthSongSeconds: Float = 0
    var startInSongSeconds: Float = 0

    let pitch : AVAudioUnitTimePitch = AVAudioUnitTimePitch()
    // Declare fixed length array of AVAudioPCMBuffers
    // Not sure how to index if dynamic so set to a fixed length
    var buffer_hi = [AVAudioPCMBuffer?](repeatElement(nil, count: 8))
    var buffer_low = [AVAudioPCMBuffer?](repeatElement(nil, count: 8))
    // End of audio file variables/constants
    
    let bufferSampleRate: Double
    let audioFormat: AVAudioFormat
    var soundBuffer = [AVAudioPCMBuffer?]()
    
    var timeInterval: TimeInterval = 0
    var divisionIndex = 0
    
    var bufferNumber = 0
    
    var syncQueue = DispatchQueue(label: "Metronome")

    var nextBeatSampleTime: AVAudioFramePosition = 0
    /// controls responsiveness to tempo changes
    var beatsToScheduleAhead  = 0
    var beatsScheduled = 0

    var playerStarted = false

    
    public init(audioFormat:AVAudioFormat, clickData: [String]) {
        
        self.audioFormat = audioFormat
        self.bufferSampleRate = audioFormat.sampleRate

        initiazeDefaults()
        
        // How many audio frames?
        let bipFrames = UInt32(Constants.kBipDurationSeconds * audioFormat.sampleRate)
        
        // Use two triangle waves which are generate for the metronome bips.
        // Create the PCM buffers.
        soundBuffer.append(AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: bipFrames))
        soundBuffer.append(AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: bipFrames))
        
        // Fill in the number of valid sample frames in the buffers (required).
        soundBuffer[0]?.frameLength = bipFrames
        soundBuffer[1]?.frameLength = bipFrames
        
        // Generate the metronme bips, first buffer will be A440 and the second buffer Middle C.
        //let wg1 = TriangleWaveGenerator(sampleRate: Float(audioFormat.sampleRate), frequency: 261.6)
        //let wg2 = TriangleWaveGenerator(sampleRate: Float(audioFormat.sampleRate))
        
        //wg1.render(soundBuffer[0]!)
        //wg2.render(soundBuffer[1]!)
        
        player.volume = 1.0
        
        // Array of urls come in pairs so only need to loop through half the array
        // First element in pair is accent while the second is non-accent
        for i in 0..<clickData.count/2 {
            let path_hi = Bundle.main.path(forResource: clickData[2*i], ofType: "wav")!
            let path_low = Bundle.main.path(forResource: clickData[2*i+1], ofType: "wav")!
            let url_hi = NSURL.fileURL(withPath: path_hi)
            let url_low = NSURL.fileURL(withPath: path_low)

            do {
                audioFile_hi = try AVAudioFile(forReading: url_hi)
            } catch {print("error")}

            do {
                audioFile_low = try AVAudioFile(forReading: url_low)
            } catch {print("error")}

            songLengthSamples_hi = audioFile_hi.length
            print("songlengthSamples_hi = \(songLengthSamples_hi)")
            songLengthSamples_low = audioFile_low.length
            print("songlengthSamples_low = \(songLengthSamples_low)")

            let songFormat = audioFile_hi.processingFormat
            sampleRateSong = Float(songFormat.sampleRate)
            print("sampleRateSong = \(sampleRateSong)")
            lengthSongSeconds = Float(songLengthSamples_hi) / sampleRateSong
            print("lengthSongSeconds = \(lengthSongSeconds)")

            buffer_hi[2*i] = AVAudioPCMBuffer(pcmFormat: audioFile_hi.processingFormat, frameCapacity: AVAudioFrameCount(/*audioFile_hi.length*/ 8000))!
            do {
                try audioFile_hi.read(into: buffer_hi[2*i]!)
            } catch _ {print("error with reading into buffer")
            }

            buffer_low[2*i+1] = AVAudioPCMBuffer(pcmFormat: audioFile_low.processingFormat, frameCapacity: AVAudioFrameCount(/*audioFile_low.length*/ 8000))!
            do {
                try audioFile_low.read(into: buffer_low[2*i+1]!)
            } catch _ {print("error with reading into buffer")
            }
        }

        pitch.pitch = 1
        pitch.rate = 1
        
        engine.attach(player)
        engine.connect(player, to:  engine.outputNode, fromBus: 0, toBus: 0, format: audioFormat)
    }
    
    deinit {
        self.stop()
        engine.detach(player)
        soundBuffer[0] = nil
        soundBuffer[1] = nil
    }
    
    // The start function has two input parameters used for synchronizing with display.
    // withReset: Boolean that is used to always put beatNumber = 0
    // inputBeatNumber: Integer that keeps track of the current beat. This will make sure that stopping the metronome at the nonzero beat and then restarting will always have the accent on beat 0
    public func start(withReset: Bool, inputBeatNumber: Int, selectedSoundIndex: Int) throws {
        
        // Start the engine without playing anything yet.
        try engine.start()
        isPlaying = true
        
        updateTimeInterval()
        nextBeatSampleTime = 0

        // Set beatNumber = 0 if reset on toggle selected
        if withReset == true {
            beatNumber = 0
        } else {
            beatNumber = inputBeatNumber
        }

        bufferNumber = 0
        
        self.syncQueue.async() {
            self.scheduleBeats(soundIndex: selectedSoundIndex)
        }
    }
    
    func initiazeDefaults() {
        tempoBPM = TempoConfig.default
        meter = MeterConfig.default
        timeInterval = 0
        divisionIndex = 1
        beatNumber = 0
        division = Constants.kDivisions[divisionIndex]
        beatsScheduled = 0
        
        sampleRateSong = 0
        lengthSongSeconds = 0
        startInSongSeconds = 0
    }

    
    public func stop() {
        isPlaying = false
        
        /* Note that pausing or stopping all AVAudioPlayerNode's connected to an engine does
         NOT pause or stop the engine or the underlying hardware.
         
         The engine must be explicitly paused or stopped for the hardware to stop.
         */
        player.stop()
        player.reset()
        
        /* Stop the audio hardware and the engine and release the resources allocated by the prepare method.
         
         Note that pause will also stop the audio hardware and the flow of audio through the engine, but
         will not deallocate the resources allocated by the prepare method.
         
         It is recommended that the engine be paused or stopped (as applicable) when not in use,
         to minimize power consumption.
         */
        engine.stop()
        playerStarted = false
    }
    
    public func incrementTempo(by increment: Int) {
        tempoBPM += increment;
        tempoBPM = min(max(tempoBPM, TempoConfig.min), TempoConfig.max)
        updateTimeInterval()
    }
    
    public func setTempo(to value: Int) {
        tempoBPM = min(max(value, TempoConfig.min), TempoConfig.max)
        updateTimeInterval()
    }
    
    public func incrementMeter(by increment: Int) {
        meter += increment;
        meter = min(max(meter, MeterConfig.min), MeterConfig.max)
        beatNumber = 0
    }
    
    public func incrementDivisionIndex(by increment: Int) throws {
        
        let wasRunning = isPlaying
        
        if (wasRunning) {
            stop()
        }
        
        divisionIndex += increment
        divisionIndex = min(max(divisionIndex, 0), Constants.kDivisions.count - 1)
        division = Constants.kDivisions[divisionIndex];
        
        // Need to reset the meter if incrementing the division index
        // Input to inputBeatNumber not relevant as withReset = true
        if (wasRunning) {
            try start(withReset: true, inputBeatNumber: 0, selectedSoundIndex: 0)
        }
    }
    
    public func reset() {
        
        initiazeDefaults()
        updateTimeInterval()
        
        isPlaying = false
        playerStarted = false
    }
    
    func scheduleBeats(soundIndex: Int) {
        if (!isPlaying) { return }
        
        while (beatsScheduled < beatsToScheduleAhead) {
            // Schedule the beat.
            
            let playerBeatTime = AVAudioTime(sampleTime: nextBeatSampleTime, atRate: bufferSampleRate)
            // This time is relative to the player's start time.
            if beatNumber == 0 {
                player.scheduleBuffer(buffer_hi[2*soundIndex]!, at: playerBeatTime, options: AVAudioPlayerNodeBufferOptions(rawValue: 0), completionHandler: {
                self.syncQueue.async() {
                    self.beatsScheduled -= 1
                    self.bufferNumber ^= 1
                    self.scheduleBeats(soundIndex: soundIndex)
                }
            }) } else {
                player.scheduleBuffer(buffer_low[2*soundIndex+1]!, at: playerBeatTime, options: AVAudioPlayerNodeBufferOptions(rawValue: 0), completionHandler: {
                    self.syncQueue.async() {
                        self.beatsScheduled -= 1
                        self.bufferNumber ^= 1
                        self.scheduleBeats(soundIndex: soundIndex)
                    }
                })
            }
            
            beatsScheduled += 1
            
            if (!playerStarted) {
                // We defer the starting of the player so that the first beat will play precisely
                // at player time 0. Having scheduled the first beat, we need the player to be running
                // in order for nodeTimeForPlayerTime to return a non-nil value.
                player.play()
                playerStarted = true
            }
            
            // Schedule the delegate callback (metronomeTicking:bar:beat:) if necessary.
            let callBackMeter = meter
            if let delegate = self.delegate , self.isPlaying && self.meter == callBackMeter {
                let callbackBeat = beatNumber
                let nodeBeatTime: AVAudioTime = player.nodeTime(forPlayerTime: playerBeatTime)!
                let output: AVAudioIONode = engine.outputNode
                os_log(" %@, %@, %f", playerBeatTime, nodeBeatTime, output.presentationLatency)
                
                let latencyHostTicks: UInt64 = AVAudioTime.hostTime(forSeconds: output.presentationLatency)
                let dispatchTime = DispatchTime(uptimeNanoseconds: nodeBeatTime.hostTime + latencyHostTicks)
                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: dispatchTime) {
                    delegate.metronomeTicking(self, currentTick: callbackBeat)
                }
            }
            beatNumber = (beatNumber + 1) % meter
            
            let samplesPerBeat = AVAudioFramePosition(timeInterval * bufferSampleRate)
            nextBeatSampleTime += samplesPerBeat
        }
    }
    
    func updateTimeInterval() {
        timeInterval = (60.0 / Double(tempoBPM)) * (4.0 / Double(Constants.kDivisions[divisionIndex]))
        
        beatsToScheduleAhead = Int(Constants.kTempoChangeResponsivenessSeconds / timeInterval)
        
        beatsToScheduleAhead = max(beatsToScheduleAhead, 1)
    }
}
