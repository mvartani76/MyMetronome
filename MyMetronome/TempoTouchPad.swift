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
    static var tapBPM = 120.0
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchCount = touches.count
        let touch = touches.first
        let tapCount = touch!.tapCount
        
        var thisTap = Date()
        var tapDiff = thisTap.timeIntervalSince(prevTap)
        prevTap = thisTap
        
        TempoTouchPad.tapBPM = 60.0/tapDiff
        
        print("touches began")
        print("\(touchCount) touches")
        print("\(tapCount) taps")
        print("Time is \(thisTap)")
        print("Time diff is \(tapDiff)")
        print("bpm is \(60.0/tapDiff)")
        
    }

}
