//
//  MeterView.swift
//  MyMetronome
//
//  Created by Michael Vartanian on 8/5/19.
//  Copyright © 2019 Michael Vartanian. All rights reserved.
//

import UIKit

class MeterView: UIView {

    var numBeats: Int = 4 { didSet {
        numBeats = max(1, numBeats)
        }
    }
    var currentBeat: Int = 0 { didSet {
        currentBeat = min(max(0, currentBeat), numBeats)
        }
    }

    override func draw(_ rect: CGRect) {
        var path = UIBezierPath()
        
        // Set the width of the circles to fit in the frame making sure not to overflow the frame height
        let circleWidth = min(frame.size.width / CGFloat(numBeats) - MeterConstants.meterCircleLineWidth, frame.size.height - MeterConstants.meterCircleLineWidth)
        let circleHeight = circleWidth
        let circleYPosition = frame.size.height / 2 - circleHeight / 2
        
        // Calculate the remaining space between the frame and circles for centering the circles within the frame
        let widthDiffOffset = (frame.size.width - ((circleWidth + MeterConstants.meterCircleLineWidth ) * CGFloat(numBeats))) / 2

        for i in 1...numBeats {
            path = UIBezierPath(ovalIn: CGRect(x: CGFloat(i - 1)*(circleWidth+MeterConstants.meterCircleLineWidth)+widthDiffOffset+MeterConstants.meterCircleLineWidth/2, y:circleYPosition, width: circleWidth, height: circleHeight))
            UIColor.init(red: 7/255, green: 41/255, blue: 97/255, alpha: 1.0).setStroke()
            if i == currentBeat {
                UIColor.init(red: 85/255, green: 139/255, blue: 224/255, alpha: 1.0).setFill()
            } else {
                UIColor.init(red: 28/255, green: 85/255, blue: 176/255, alpha: 1.0).setFill()
            }
            path.lineWidth = MeterConstants.meterCircleLineWidth
            path.stroke()
            path.fill()
        }
    }
    func updateMeter() {
        if currentBeat < numBeats {
            currentBeat = currentBeat + 1
        } else {
            currentBeat = 1
        }
    }
}
