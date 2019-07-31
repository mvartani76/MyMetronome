//
//  MyMetronome.swift
//  MyMetronome
//
//  Created by Michael Vartanian on 7/5/19.
//  Copyright © 2019 Michael Vartanian. All rights reserved.
//

import Foundation
import AVFoundation

class Metronome {
    var bpm: Float = 60.0 { didSet {
        bpm = min(300.0,max(30.0,bpm))
        }}
    var enabled: Bool = false { didSet {
        if enabled {
            start()
        } else {
            stop()
        }
        }}
    var onTick: ((_ nextTick: DispatchTime) -> Void)?
    var nextTick: DispatchTime = DispatchTime.distantFuture
    
    let player: AVAudioPlayer = {
        do {
            let soundURL = Bundle.main.url(forResource: "/Samples/Woodblock", withExtension: "wav")!
            let soundFile = try AVAudioFile(forReading: soundURL)
            let player = try AVAudioPlayer(contentsOf: soundURL)
            return player
        } catch {
            print("Oops, unable to initialize metronome audio buffer: \(error)")
            return AVAudioPlayer()
        }
    }()
    
    private func start() {
        print("Starting metronome, BPM: \(bpm)")
        nextTick = DispatchTime.now()
        player.prepareToPlay()
        nextTick = DispatchTime.now()
        tick()
    }
    
    private func stop() {
        player.stop()
        print("Stopping metronome")
    }
    
    private func tick() {
        guard
            enabled,
            nextTick <= DispatchTime.now()
            else { return }
        
        let interval: TimeInterval = 60.0 / TimeInterval(bpm)
        nextTick = nextTick + interval
        DispatchQueue.main.asyncAfter(deadline: nextTick) { [weak self] in
            self?.tick()
        }
        // player.play(atTime) is not playing any sound
        // https://stackoverflow.com/questions/43899431/why-calling-audioplayer-playattime-delay-makes-no-sound-regardless-of-the-val
        // The above link says we need to add player.deviceCurrentTime but then the bpm is much slower
        //player.play(atTime: interval)
        player.play()
        onTick?(nextTick)
    }
}
