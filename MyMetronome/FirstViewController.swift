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
    
    @IBOutlet var startStopButton: UIButton!
    @IBOutlet var tickLabel: UILabel!
    @IBOutlet var bpmLabel: UILabel!
    
    
    
    var isToggled = false
    
    let myMetronome = Metronome()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myMetronome.onTick = { (nextTick) in
            self.animateTick()
        }
        updateBpm()
    }
    
    private func animateTick() {
        tickLabel.alpha = 1.0
        UIView.animate(withDuration: 0.35) {
            self.tickLabel.alpha = 0.0
        }
    }
    
    @IBAction func handleKnobChange(_ sender: Any) {
        updateBpm()
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
    
    private func updateBpm() {
        //let metronomeBpm = Int(myMetronome.bpm)
        myMetronome.bpm = Float(knob.value)
        //bpmLabel.text = "\(metronomeBpm)"
        bpmLabel.text = String(format: "%.2f", knob.value)
    }
    

}

