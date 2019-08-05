//
//  FirstViewController.swift
//  MyMetronome
//
//  Created by Michael Vartanian on 7/5/19.
//  Copyright © 2019 Michael Vartanian. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet var knob: Knob3!
    @IBOutlet var myMeterView: MeterView!
    
    @IBOutlet var startStopButton: UIButton!
    @IBOutlet var tickLabel: UILabel!
    @IBOutlet var bpmLabel: UILabel!
    @IBOutlet var incBPMButton: UIButton!
    @IBOutlet var decBPMButton: UIButton!
    
    var isToggled = false
    
    let myMetronome = Metronome()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myMetronome.onTick = { (nextTick) in
            self.animateTick()
        }
        updateBpm(newBPM: Float(knob.value))
        myMeterView.numBeats = 4
        // Initialize the currentBeat to 0 to have the first tick highlight the leftmost circle
        myMeterView.currentBeat = 0
    }
    
    private func animateTick() {
        tickLabel.alpha = 1.0
        UIView.animate(withDuration: 0.35) {
            self.tickLabel.alpha = 0.0
        }

        print(myMeterView.currentBeat)
        myMeterView.setNeedsDisplay()
        
        myMeterView.updateMeter()
    }
    
    @IBAction func handleKnobChange(_ sender: Any) {
        updateBpm(newBPM: Float(knob.value))
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
    
    
    private func updateBpm(newBPM: Float) {
        myMetronome.bpm = min(max(30, newBPM), 300)
        bpmLabel.text = String(format: "%.0f", myMetronome.bpm)
        knob.value = myMetronome.bpm
    }
    

}

