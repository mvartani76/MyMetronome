//
//  MetronomeViewController.swift
//  MyMetronome
//
//  Created by Michael Vartanian on 7/5/19.
//  Copyright © 2019 Michael Vartanian. All rights reserved.
//

import UIKit

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
    
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Connect data:
        self.numBeatsPickerView.delegate = self
        self.numBeatsPickerView.dataSource = self
        self.beatNotePickerView.delegate = self
        self.beatNotePickerView.dataSource = self
        
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
        
        numBeatsPickerView.selectRow(numBeatsData.firstIndex(of: .defaultNumBeats)!, inComponent: 0, animated: true)
        beatNotePickerView.selectRow(beatNoteData.firstIndex(of: .defaultNumBeats)!, inComponent: 0, animated: true)
    }
    
    private func animateTick() {
        myMeterView.setNeedsDisplay()
        myMeterView.updateMeter()
    }
    
    @IBAction func handleKnobChange(_ sender: Any) {
        updateBpm(newBPM: Double(knob.value))
    }
    
    @IBAction func toggleMetronomeButton(_ sender: UIButton) {
        if !isToggled {
            myMetronome.enabled = true
            isToggled = true
            startStopButton.setTitle("Stop", for: .normal)
            startStopButton.backgroundColor = UIColor.init(red: 85/255, green: 139/255, blue: 224/255, alpha: 1.0)
        } else {
            myMetronome.enabled = false
            isToggled = false
            startStopButton.setTitle("Start", for: .normal)
            startStopButton.backgroundColor = UIColor.init(red: 28/255, green: 85/255, blue: 176/255, alpha: 1.0)
        }
    }
    
    @IBAction func incrementBPM(_ sender: UIButton) {
        updateBpm(newBPM: myMetronome.bpm + 1.0)
    }
    
    @IBAction func decrementBPM(_ sender: UIButton) {
        updateBpm(newBPM: myMetronome.bpm - 1.0)
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
}
