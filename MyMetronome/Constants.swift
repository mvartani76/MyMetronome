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
    public static let defaultMinTempo_seconds = numSecondsInMinute / defaultMinTempo
    public static let defaultMaxTempo_seconds = numSecondsInMinute / defaultMaxTempo
    public static let tapBPMFiltCoeff = 0.4
}

extension TimeInterval {
    public static let numSecondsInMinute = 60.0
}

extension UIColor {
    public static let buttonPrimaryEnabledColor = UIColor.init(red: 85/255, green: 139/255, blue: 224/255, alpha: 1.0)
    public static let buttonPrimaryDisabledColor = UIColor.init(red: 28/255, green: 85/255, blue: 176/255, alpha: 1.0)
    public static let tapViewShadowColor = UIColor.init(red: 147/255, green: 199/255, blue: 253/255, alpha: 1.0)
    public static let meterViewAccentFillColor = UIColor.init(red: 85/255, green: 139/255, blue: 224/255, alpha: 1.0)
    public static let meterViewNormalFillColor = UIColor.init(red: 28/255, green: 85/255, blue: 176/255, alpha: 1.0)
    public static let meterViewStrokeColor = UIColor.init(red: 7/255, green: 41/255, blue: 97/255, alpha: 1.0)
}

extension CGColor {
    public static let tapViewShadowColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [CGFloat(147.0/255.0), CGFloat(199.0/255.0), CGFloat(253.0/255.0), 1.0])
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

struct TouchPadConstants {
    static let tapViewShadowRadius: CGFloat = 20
    static let tapViewShadowOpacity: Float = 0.0
    static let tapViewAnimationDuration: Double = 0.2
    static let tapViewAnimationFromValue: Double = 1.0
    static let tapViewAnimationToValue: Double = 0.0
}

struct CustomFontConstants {
    static let emberFontTitleSize: CGFloat = 37
    static let emberFontBPMSize: CGFloat = 28
    static let emberFontincBPMSize: CGFloat = 30
    static let emberFontdecBPMSize: CGFloat = 30
    static let emberPickerFontSize: CGFloat = 24
    static let emberFontTimeSize: CGFloat = 24
    static let emberFontStartButtonSize: CGFloat = 26
    static let emberFontEnableTapSize: CGFloat = 16
    static let emberFontLabelSize: CGFloat = 32
    static let emberColorLabelSize: CGFloat = 30
    static let emberSoundsLabelSize: CGFloat = 30
    static let emberResetMetroLabelSize: CGFloat = 24
    static let grinchedFontTitleSize: CGFloat = 42
    static let grinchedFontBPMSize: CGFloat = 28
    static let grinchedFontincBPMSize: CGFloat = 30
    static let grinchedFontdecBPMSize: CGFloat = 30
    static let grinchedPickerFontSize: CGFloat = 26
    static let grinchedFontTimeSize: CGFloat = 26
    static let grinchedFontStartButtonSize: CGFloat = 28
    static let grinchedFontEnableTapSize: CGFloat = 20
    static let grinchedFontLabelSize: CGFloat = 38
    static let grinchedColorLabelSize: CGFloat = 38
    static let grinchedSoundsLabelSize: CGFloat = 38
    static let grinchedResetMetroLabelSize: CGFloat = 28
    static let partyPlainFontTitleSize: CGFloat = 55
    static let partyPlainFontBPMSize: CGFloat = 30
    static let partyPlainFontincBPMSize: CGFloat = 44
    static let partyPlainFontdecBPMSize: CGFloat = 44
    static let partyPlainPickerFontSize: CGFloat = 34
    static let partyPlainFontTimeSize: CGFloat = 34
    static let partyPlainFontStartButtonSize: CGFloat = 38
    static let partyPlainFontEnableTapSize: CGFloat = 28
    static let partyPlainFontLabelSize: CGFloat = 46
    static let partyPlainColorLabelSize: CGFloat = 46
    static let partyPlainSoundsLabelSize: CGFloat = 46
    static let partyPlainResetMetroLabelSize: CGFloat = 36
    static let gooddogFontTitleSize: CGFloat = 55
    static let gooddogFontBPMSize: CGFloat = 45
    static let gooddogFontincBPMSize: CGFloat = 38
    static let gooddogFontdecBPMSize: CGFloat = 38
    static let gooddogPickerFontSize: CGFloat = 40
    static let gooddogFontTimeSize: CGFloat = 40
    static let gooddogFontStartButtonSize: CGFloat = 32
    static let gooddogFontEnableTapSize: CGFloat = 23
    static let gooddogFontLabelSize: CGFloat = 46
    static let gooddogColorLabelSize: CGFloat = 45
    static let gooddogSoundsLabelSize: CGFloat = 45
    static let gooddogResetMetroLabelSize: CGFloat = 30
    static let defaultPickerFontSize: CGFloat = 22
}

struct CustomColorConstants {
    static let bluesPrimaryButtonEnabledColor: UIColor = UIColor.init(red: 85/255, green: 139/255, blue: 224/255, alpha: 1.0)
    static let bluesPrimaryButtonDisabledColor: UIColor = UIColor.init(red: 28/255, green: 85/255, blue: 176/255, alpha: 1.0)
    static let bluesSecondaryButtonColor: UIColor = UIColor.init(red: 62/255, green: 107/255, blue: 180/255, alpha: 1.0)
    static let bluesMeterViewAccentColor: UIColor = UIColor.init(red: 85/255, green: 139/255, blue: 224/255, alpha: 1.0)
    static let bluesMeterViewNormalColor: UIColor = UIColor.init(red: 28/255, green: 85/255, blue: 176/255, alpha: 1.0)
    static let bluesMeterViewStrokeColor: UIColor = UIColor.init(red: 7/255, green: 41/255, blue: 97/255, alpha: 1.0)
    static let bluesKnobOuterLayerFillColor: UIColor = UIColor.init(red: 7/255, green: 41/255, blue: 97/255, alpha: 1.0)
    static let bluesKnobOuterLayerStrokeColor: UIColor = UIColor.blue
    static let bluesKnobMiddleLayer1FillColor: UIColor = UIColor.init(red: 28/255, green: 85/255, blue: 176/255, alpha: 1.0)
    static let bluesKnobMiddleLayer2FillColor: UIColor = UIColor.init(red: 85/255, green: 139/255, blue: 224/255, alpha: 1.0)
    static let bluesKnobPointerLayerStrokeColor: UIColor = UIColor.white
    static let pinksPrimaryButtonEnabledColor: UIColor = UIColor.init(red: 250/255, green: 162/255, blue: 225/255, alpha: 1.0)
    static let pinksPrimaryButtonDisabledColor: UIColor = UIColor.init(red: 235/255, green: 52/255, blue: 183/255, alpha: 1.0)
    static let pinksSecondaryButtonColor: UIColor = UIColor.init(red: 230/255, green: 117/255, blue: 175/255, alpha: 1.0)
    static let pinksMeterViewAccentColor: UIColor = UIColor.init(red: 250/255, green: 162/255, blue: 225/255, alpha: 1.0)
    static let pinksMeterViewNormalColor: UIColor = UIColor.init(red: 235/255, green: 52/255, blue: 183/255, alpha: 1.0)
    static let pinksMeterViewStrokeColor: UIColor = UIColor.init(red: 179/255, green: 32/255, blue: 137/255, alpha: 1.0)
    static let pinksKnobOuterLayerFillColor: UIColor = UIColor.init(red: 179/255, green: 32/255, blue: 137/255, alpha: 1.0)
    static let pinksKnobOuterLayerStrokeColor: UIColor = UIColor.systemPink
    static let pinksKnobMiddleLayer1FillColor: UIColor = UIColor.init(red: 235/255, green: 52/255, blue: 183/255, alpha: 1.0)
    static let pinksKnobMiddleLayer2FillColor: UIColor = UIColor.init(red: 250/255, green: 162/255, blue: 225/255, alpha: 1.0)
    static let pinksKnobPointerLayerStrokeColor: UIColor = UIColor.white
    static let purplesPrimaryButtonEnabledColor: UIColor = UIColor.init(red: 223/255, green: 126/255, blue: 242/255, alpha: 1.0)
    static let purplesPrimaryButtonDisabledColor: UIColor = UIColor.init(red: 159/255, green: 35/255, blue: 184/255, alpha: 1.0)
    static let purplesSecondaryButtonColor: UIColor = UIColor.init(red: 194/255, green: 119/255, blue: 209/255, alpha: 1.0)
    static let purplesMeterViewAccentColor: UIColor = UIColor.init(red: 223/255, green: 126/255, blue: 242/255, alpha: 1.0)
    static let purplesMeterViewNormalColor: UIColor = UIColor.init(red: 235/255, green: 52/255, blue: 183/255, alpha: 1.0)
    static let purplesMeterViewStrokeColor: UIColor = UIColor.init(red: 125/255, green: 22/255, blue: 145/255, alpha: 1.0)
    static let purplesKnobOuterLayerFillColor: UIColor = UIColor.init(red: 125/255, green: 22/255, blue: 145/255, alpha: 1.0)
    static let purplesKnobOuterLayerStrokeColor: UIColor = UIColor.purple
    static let purplesKnobMiddleLayer1FillColor: UIColor = UIColor.init(red: 208/255, green: 16/255, blue: 200/255, alpha: 1.0)
    static let purplesKnobMiddleLayer2FillColor: UIColor = UIColor.init(red: 223/255, green: 126/255, blue: 242/255, alpha: 1.0)
    static let purplesKnobPointerLayerStrokeColor: UIColor = UIColor.white
    static let greensPrimaryButtonEnabledColor: UIColor = UIColor.init(red: 85/255, green: 224/255, blue: 139/255, alpha: 1.0)
    static let greensPrimaryButtonDisabledColor: UIColor = UIColor.init(red: 28/255, green: 176/255, blue: 85/255, alpha: 1.0)
    static let greensSecondaryButtonColor: UIColor = UIColor.init(red: 62/255, green: 180/255, blue: 107/255, alpha: 1.0)
    static let greensMeterViewAccentColor: UIColor = UIColor.init(red: 85/255, green: 224/255, blue: 139/255, alpha: 1.0)
    static let greensMeterViewNormalColor: UIColor = UIColor.init(red: 28/255, green: 176/255, blue: 85/255, alpha: 1.0)
    static let greensMeterViewStrokeColor: UIColor = UIColor.init(red: 7/255, green: 97/255, blue: 41/255, alpha: 1.0)
    static let greensKnobOuterLayerFillColor: UIColor = UIColor.init(red: 7/255, green: 97/255, blue: 41/255, alpha: 1.0)
    static let greensKnobOuterLayerStrokeColor: UIColor = UIColor.green
    static let greensKnobMiddleLayer1FillColor: UIColor = UIColor.init(red: 28/255, green: 176/255, blue: 85/255, alpha: 1.0)
    static let greensKnobMiddleLayer2FillColor: UIColor = UIColor.init(red: 85/255, green: 224/255, blue: 139/255, alpha: 1.0)
    static let greensKnobPointerLayerStrokeColor: UIColor = UIColor.white
}
