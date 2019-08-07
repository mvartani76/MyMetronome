//
//  MetronomeViewController.swift
//  MyMetronome
//
//  Created by Michael Vartanian on 7/5/19.
//  Copyright © 2019 Michael Vartanian. All rights reserved.
//

import UIKit
import AVFoundation
import os

class MetronomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Input the data into the array
    var numBeatsData = ["1", "2", "3", "4", "5", "6"]
    var beatNoteData = ["1", "2", "3", "4", "5", "6"]
    
    var numBeats: Int = .defaultNumBeats
    var beatNote: Int = .defaultBeatNote
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == numBeatsPickerView {
            return numBeatsData.count
        }
        else if pickerView == beatNotePickerView {
            return beatNoteData.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == numBeatsPickerView {
            return numBeatsData[row]
        } else {
            return beatNoteData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == numBeatsPickerView {
            numBeats = Int(numBeatsData[row]) ?? .defaultNumBeats
        } else if pickerView == beatNotePickerView {
            beatNote = Int(beatNoteData[row]) ?? .defaultNumBeats
        }
        updateTimeSignature(numBeats: numBeats, beatNote: beatNote)
    }
    
    @IBOutlet var knob: Knob3!
    @IBOutlet var myMeterView: MeterView!
    
    @IBOutlet var startStopButton: UIButton!
    @IBOutlet var tickLabel: UILabel!
    @IBOutlet var bpmLabel: UILabel!
    @IBOutlet var incBPMButton: UIButton!
    @IBOutlet var decBPMButton: UIButton!
    @IBOutlet var timeSignatureLabel: UILabel!
    @IBOutlet var numBeatsPickerView: UIPickerView!
    @IBOutlet var beatNotePickerView: UIPickerView!
    
    
    var isToggled = false
    
    let myMetronome = Metronome()
    var metronome: Metronome2!
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Connect data:
        self.numBeatsPickerView.delegate = self
        self.numBeatsPickerView.dataSource = self
        self.beatNotePickerView.delegate = self
        self.beatNotePickerView.dataSource = self
        
        
        guard let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2) else {
            return
        }
        metronome = Metronome2(audioFormat: format)
        metronome.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleMediaServicesWereReset), name: AVAudioSession.mediaServicesWereResetNotification, object: AVAudioSession.sharedInstance())

        
        myMeterView.numBeats = .defaultNumBeats
        knob.value = Float(myMetronome.bpm)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myMetronome.onTick = { (nextTick) in
            self.animateTick()
        }
        updateBpm(newBPM: Double(knob.value))
        updateTimeSignature(numBeats: .defaultNumBeats, beatNote: .defaultBeatNote)
        
        // Initialize the currentBeat to 0 to have the first tick highlight the leftmost circle
        myMeterView.currentBeat = 0
        updateMeterLabel()
        numBeatsPickerView.selectRow(numBeatsData.firstIndex(of: .defaultNumBeats)!, inComponent: 0, animated: true)
        beatNotePickerView.selectRow(beatNoteData.firstIndex(of: .defaultNumBeats)!, inComponent: 0, animated: true)
    }
    
/* To fix the inconsistent timing, incorporating updates from
https://github.com/xiangyu-sun/XSMetronome/blob/master/Metronome/MainViewController.swift
*/
    @objc func handleMediaServicesWereReset()  {
        os_log("audio reset")
        metronome.delegate = nil
        metronome.reset()
        
        updateMeterLabel()
        
        metronome.delegate = self
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        }catch {
            os_log("%@", error.localizedDescription)
        }
    }
    
    private func animateTick() {
        myMeterView.setNeedsDisplay()
        myMeterView.updateMeter()
    }
    
    @IBAction func handleKnobChange(_ sender: Any) {
        updateBpm(newBPM: Double(knob.value))
        metronome.setTempo(to: Int(knob.value))
    }
    
    @IBAction func toggleMetronomeButton(_ sender: UIButton) {
        if !isToggled {
            //myMetronome.enabled = true
            try? metronome.start()
            isToggled = true
            startStopButton.setTitle("Stop", for: .normal)
            startStopButton.backgroundColor = UIColor.init(red: 85/255, green: 139/255, blue: 224/255, alpha: 1.0)
        } else {
            //myMetronome.enabled = false
            metronome.stop()
            isToggled = false
            startStopButton.setTitle("Start", for: .normal)
            startStopButton.backgroundColor = UIColor.init(red: 28/255, green: 85/255, blue: 176/255, alpha: 1.0)
        }
    }
    
    @IBAction func incrementBPM(_ sender: UIButton) {
        updateBpm(newBPM: myMetronome.bpm + 1.0)
        metronome.incrementTempo(by: 1)
    }
    
    @IBAction func decrementBPM(_ sender: UIButton) {
        updateBpm(newBPM: myMetronome.bpm - 1.0)
        metronome.incrementTempo(by: 1)
    }
    

    private func updateBpm(newBPM: Double) {
        myMetronome.bpm = min(max(.defaultMinTempo, newBPM), .defaultMaxTempo)
        bpmLabel.text = String(format: "%.0f", myMetronome.bpm)
        knob.value = Float(myMetronome.bpm)
    }
    
    private func updateTimeSignature(numBeats: Int, beatNote: Int) {
        timeSignatureLabel.text = "\(numBeats)/\(beatNote)"
        myMeterView.numBeats = numBeats
        myMeterView.setNeedsDisplay()
    }
    
    func updateMeterLabel() {
        timeSignatureLabel.text = "\(metronome.meter) / \(metronome.division)"
    }
}

/* To fix the inconsistent timing, incorporating updates from
 https://github.com/xiangyu-sun/XSMetronome/blob/master/Metronome/MainViewController.swift
*/
extension MetronomeViewController: MetronomeDelegate {
    func metronomeTicking(_ metronome: Metronome2, currentTick: Int) {
        DispatchQueue.main.async {
            //self.updateArcWithTick(currentTick: currentTick)
            print(currentTick)
            self.myMeterView.setNeedsDisplay()
            self.myMeterView.updateMeter()
        }
    }
}
