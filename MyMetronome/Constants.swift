//
//  Constants.swift
//  MyMetronome
//
//  Created by Michael Vartanian on 8/6/19.
//  Copyright © 2019 Michael Vartanian. All rights reserved.
//

import Foundation
import UIKit

extension String {
    public static let defaultNumBeats = "4"
}

extension Int {
    public static let defaultNumBeats = 4
    public static let defaultBeatNote = 4
}

extension Double {
    public static let defaultMinTempo = 30.0
    public static let defaultMaxTempo = 300.0
    public static let startingTempo = 120.0
}

extension TimeInterval {
    public static let numSecondsInMinute = 60.0
}

struct MeterConstants {
    static let meterCircleLineWidth: CGFloat = 5
}

struct KnobConstants {
    static let minknobvalue: Float = 0.0
    static let maxknobvalue: Float = 1.0
    static let startKnobAngle: CGFloat = -CGFloat.pi * 11 / 8.0
    static let endKnobAngle: CGFloat = CGFloat.pi * 3 / 8.0
    static let radius_middle1_offset: CGFloat = 10
    static let radius_middle2_offset: CGFloat = 25
    static let pointer_offset1: CGFloat = 20
    static let pointer_offset2: CGFloat = 5
    static let slidingSensitivity: CGFloat = 0.005
}
