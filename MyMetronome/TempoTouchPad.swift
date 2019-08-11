//
//  TempoTouchPad.swift
//  MyMetronome
//
//  Created by Michael Vartanian on 8/7/19.
//  Copyright © 2019 Michael Vartanian. All rights reserved.
//

import UIKit

class TempoTouchPad: UIControl {

    var prevTap = Date()
    public static var tapBPM: Double = .startingTempo
    // Initialize the current/previous difference to 0.5 or tempo = 120bpm
    var prevDiff = .numSecondsInMinute / .startingTempo
    var tapDiff = .numSecondsInMinute / .startingTempo
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let thisTap = Date()
        tapDiff = thisTap.timeIntervalSince(prevTap)
        prevTap = thisTap
        
        // Clip the difference to equate to min bpm of 30 and max bpm of 300
        tapDiff = max(.defaultMaxTempo_seconds, min(.defaultMinTempo_seconds, tapDiff))
        
        let curBPM = .numSecondsInMinute/tapDiff
        
        // Filter the tap BPM so it is not super sensitive on output
        TempoTouchPad.tapBPM = (1.0 - .tapBPMFiltCoeff) * TempoTouchPad.tapBPM + .tapBPMFiltCoeff * curBPM
        
    }

}
