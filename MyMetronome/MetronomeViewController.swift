//
//  MetronomeViewController.swift
//  MyMetronome
//
//  Created by Michael Vartanian on 7/5/19.
//  Copyright © 2019 Michael Vartanian. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass
import AVFoundation
import os

class MetronomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var mySettingsViewController = SettingsViewController()

    // Font/Color Picker Data
    var fontData = ["Ember", "Grinched", "PartyLetPlain", "GooddogPlain"]
    var colorData = ["Blues", "Pinks", "Purples", "Greens"]
    
    var customPrimaryButtonEnabledColor: UIColor = CustomColorConstants.bluesPrimaryButtonEnabledColor
    var customPrimaryButtonDisabledColor: UIColor = CustomColorConstants.bluesPrimaryButtonDisabledColor
    var customSecondaryButtonColor: UIColor = CustomColorConstants.bluesSecondaryButtonColor
    var customPrimaryStrokeColor: UIColor = CustomColorConstants.bluesMeterViewStrokeColor
    var customOuterLayerFillColor: UIColor = CustomColorConstants.bluesKnobOuterLayerFillColor
    var customOuterLayerStrokeColor: UIColor = CustomColorConstants.bluesKnobOuterLayerStrokeColor
    var customMiddleLayer1FillColor: UIColor = CustomColorConstants.bluesKnobMiddleLayer1FillColor
    var customMiddleLayer2FillColor: UIColor = CustomColorConstants.bluesKnobMiddleLayer2FillColor
    var customPointerLayerStrokeColor: UIColor = CustomColorConstants.bluesKnobPointerLayerStrokeColor

    // Input the data into the array
    var numBeatsData = ["2", "3", "4", "6", "8", "12"]
    var beatNoteData = ["4", "8", "16"]
    
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
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        let myFont = UserDefaults.standard.string(forKey: "font") ?? fontData[0]
        var pickerFontSize: CGFloat = CustomFontConstants.defaultPickerFontSize
        
        switch myFont {
        case fontData[0]:
            pickerFontSize = CustomFontConstants.emberPickerFontSize
        case fontData[1]:
            pickerFontSize = CustomFontConstants.grinchedPickerFontSize
        case fontData[2]:
            pickerFontSize = CustomFontConstants.partyPlainPickerFontSize
        case fontData[3]:
            pickerFontSize = CustomFontConstants.gooddogPickerFontSize
        default:
            pickerFontSize = CustomFontConstants.defaultPickerFontSize
        }
        label.font = UIFont(name: myFont, size: pickerFontSize)
        label.textAlignment = .center

        if pickerView == numBeatsPickerView {
            label.text = numBeatsData[row]
        } else {
            label.text = beatNoteData[row]
        }

        return label
    }
    
    @IBOutlet var knob: Knob3!
    @IBOutlet var myMeterView: MeterView!
    
    @IBOutlet var startStopButton: UIButton!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var tickLabel: UILabel!
    @IBOutlet var bpmLabel: UILabel!
    @IBOutlet var incBPMButton: UIButton!
    @IBOutlet var decBPMButton: UIButton!
    @IBOutlet var timeSignatureLabel: UILabel!
    @IBOutlet var tapView: TempoTouchPad!

    @IBOutlet var tapButton: UIButton!
    
    @IBOutlet var numBeatsPickerView: UIPickerView!
    @IBOutlet var beatNotePickerView: UIPickerView!
    
    var isToggled = false
    var tapToggled = false
    
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
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.someAction (_:)))
        
        self.tapView.addGestureRecognizer(gesture)
        
        startStopButton.backgroundColor = .buttonPrimaryDisabledColor
        tapButton.backgroundColor = .buttonPrimaryDisabledColor
        tapButton.titleLabel?.textAlignment = NSTextAlignment.center
        tapButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        tapButton.titleLabel?.numberOfLines = 2
        
        
        for family: String in UIFont.familyNames
        {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let myFont = UserDefaults.standard.string(forKey: "font") ?? fontData[0]
        print("myFont = \(myFont)")
        let myColorScheme = UserDefaults.standard.string(forKey: "colorScheme") ?? colorData[0]
        
        // Update the fonts
        updateMetronomeFonts(customFontType: myFont)

        // Update the colors
        updateMetronomeColors(customColorType: myColorScheme)

        myMetronome.onTick = { (nextTick) in
            self.animateTick()
        }
        updateBpm(newBPM: Double(knob.value))
        updateTimeSignature(numBeats: .defaultNumBeats, beatNote: .defaultBeatNote)
        
        // Initialize the currentBeat to 0 to have the first tick highlight the leftmost circle
        myMeterView.currentBeat = 0
        updateMeterLabel()
        bpmLabel.layer.zPosition = 1
        numBeatsPickerView.selectRow(numBeatsData.firstIndex(of: .defaultNumBeats)!, inComponent: 0, animated: true)
        beatNotePickerView.selectRow(beatNoteData.firstIndex(of: .defaultNumBeats)!, inComponent: 0, animated: true)
        
        // Need to reload all components to update the font if changed in settings view controller
        numBeatsPickerView.reloadAllComponents()
        beatNotePickerView.reloadAllComponents()
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
            startStopButton.backgroundColor = customPrimaryButtonEnabledColor
        } else {
            //myMetronome.enabled = false
            metronome.stop()
            isToggled = false
            startStopButton.setTitle("Start", for: .normal)
            startStopButton.backgroundColor = customPrimaryButtonDisabledColor
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
    @IBAction func toggleTapButton(_ sender: UIButton) {
        if !tapToggled {
            tapToggled = true
            tapButton.backgroundColor = customPrimaryButtonEnabledColor
            tapButton.setTitle("Disable Tempo Tap", for: .normal)
        } else {
            tapToggled = false
            tapButton.backgroundColor = customPrimaryButtonDisabledColor
            tapButton.setTitle("Enable Tempo Tap", for: .normal)
        }
    }
    
    @objc func someAction(_ sender:UITapGestureRecognizer){
        print("view was clicked")
        if tapToggled {
            bpmLabel.text = String(format: "%.0f", TempoTouchPad.tapBPM)
            metronome.setTempo(to: Int(TempoTouchPad.tapBPM))

            tapView.layer.shadowOffset = .zero
            tapView.layer.shadowColor = .tapViewShadowColor
            tapView.layer.shadowRadius = TouchPadConstants.tapViewShadowRadius
            tapView.layer.shadowOpacity = TouchPadConstants.tapViewShadowOpacity
            tapView.layer.shadowPath = UIBezierPath(rect: tapView.bounds).cgPath

            tapView.animateProperty(layer: tapView.layer, property: "shadowOpacity", fromValue: TouchPadConstants.tapViewAnimationFromValue, toValue: TouchPadConstants.tapViewAnimationToValue, duration: TouchPadConstants.tapViewAnimationDuration, timingFunction: CAMediaTimingFunctionName.easeOut, isRemovedonCompletion: false, autoReverses: false)
        }
    }
    
    private func updateTimeSignature(numBeats: Int, beatNote: Int) {
        timeSignatureLabel.text = "\(numBeats)/\(beatNote)"
        metronome.meter = numBeats
        myMeterView.numBeats = numBeats
        myMeterView.currentBeat = 0
        metronome.beatNumber = 0
        myMeterView.setNeedsDisplay()
        print("update time signature")
    }
    
    func updateMeterLabel() {
        timeSignatureLabel.text = "\(metronome.meter) / \(metronome.division)"
    }
    
    func updateMetronomeFonts(customFontType: String) {
        var customFontTitleSizeVar: CGFloat
        var customFontBPMSizeVar: CGFloat
        var customFontincBPMSizeVar: CGFloat
        var customFontdecBPMSizeVar: CGFloat
        var customFontTimeSizeVar: CGFloat
        var customFontStartButtonSizeVar: CGFloat
        var customFontEnableTapSizeVar: CGFloat
        
        // Not all fonts are the same size so need to adjust font size depending on the chosen font
        switch customFontType {
        case fontData[0]:
            customFontTitleSizeVar = CustomFontConstants.emberFontTitleSize
            customFontBPMSizeVar = CustomFontConstants.emberFontBPMSize
            customFontincBPMSizeVar = CustomFontConstants.emberFontincBPMSize
            customFontdecBPMSizeVar = CustomFontConstants.emberFontdecBPMSize
            customFontTimeSizeVar = CustomFontConstants.emberFontTimeSize
            customFontStartButtonSizeVar = CustomFontConstants.emberFontStartButtonSize
            customFontEnableTapSizeVar = CustomFontConstants.emberFontEnableTapSize
        case fontData[1]:
            customFontTitleSizeVar = CustomFontConstants.grinchedFontTitleSize
            customFontBPMSizeVar = CustomFontConstants.grinchedFontBPMSize
            // Using gooddog font size as there is no grinched + character
            customFontincBPMSizeVar = CustomFontConstants.gooddogFontincBPMSize
            customFontdecBPMSizeVar = CustomFontConstants.grinchedFontdecBPMSize
            customFontTimeSizeVar = CustomFontConstants.grinchedFontTimeSize
            customFontStartButtonSizeVar = CustomFontConstants.grinchedFontStartButtonSize
            customFontEnableTapSizeVar = CustomFontConstants.grinchedFontEnableTapSize
        case fontData[2]:
            customFontTitleSizeVar = CustomFontConstants.partyPlainFontTitleSize
            customFontBPMSizeVar = CustomFontConstants.partyPlainFontBPMSize
            customFontincBPMSizeVar = CustomFontConstants.partyPlainFontincBPMSize
            customFontdecBPMSizeVar = CustomFontConstants.partyPlainFontdecBPMSize
            customFontTimeSizeVar = CustomFontConstants.partyPlainFontTimeSize
            customFontStartButtonSizeVar = CustomFontConstants.partyPlainFontStartButtonSize
            customFontEnableTapSizeVar = CustomFontConstants.partyPlainFontEnableTapSize
        case fontData[3]:
            customFontTitleSizeVar = CustomFontConstants.gooddogFontTitleSize
            customFontBPMSizeVar = CustomFontConstants.gooddogFontBPMSize
            customFontincBPMSizeVar = CustomFontConstants.gooddogFontincBPMSize
            customFontdecBPMSizeVar = CustomFontConstants.gooddogFontdecBPMSize
            customFontTimeSizeVar = CustomFontConstants.gooddogFontTimeSize
            customFontStartButtonSizeVar = CustomFontConstants.gooddogFontStartButtonSize
            customFontEnableTapSizeVar = CustomFontConstants.gooddogFontEnableTapSize
        default:
            customFontTitleSizeVar = CustomFontConstants.emberFontTitleSize
            customFontBPMSizeVar = CustomFontConstants.emberFontBPMSize
            customFontincBPMSizeVar = CustomFontConstants.emberFontincBPMSize
            customFontdecBPMSizeVar = CustomFontConstants.emberFontdecBPMSize
            customFontTimeSizeVar = CustomFontConstants.emberFontTimeSize
            customFontStartButtonSizeVar = CustomFontConstants.emberFontStartButtonSize
            customFontEnableTapSizeVar = CustomFontConstants.emberFontEnableTapSize
        }
        topLabel.font = UIFont(name: customFontType, size: customFontTitleSizeVar)
        bpmLabel.font = UIFont(name: customFontType, size: customFontBPMSizeVar)
        timeSignatureLabel.font = UIFont(name: customFontType, size: customFontTimeSizeVar)
        startStopButton.titleLabel?.font = UIFont(name: customFontType, size: customFontStartButtonSizeVar)
        tapButton.titleLabel?.font = UIFont(name: customFontType, size: customFontEnableTapSizeVar)
        // Grinched font does not have a + sign so need to use other font
        // Not sure if I like using fontData for this conditional
        if customFontType == fontData[1] {
            incBPMButton.titleLabel?.font = UIFont(name: fontData[3], size: customFontincBPMSizeVar)
        } else {
            incBPMButton.titleLabel?.font = UIFont(name: customFontType, size: customFontincBPMSizeVar)
        }
        decBPMButton.titleLabel?.font = UIFont(name: customFontType, size: customFontdecBPMSizeVar)
    }

    func updateMetronomeColors(customColorType: String) {

        switch customColorType {
        case colorData[0]:
            customPrimaryButtonEnabledColor = CustomColorConstants.bluesPrimaryButtonEnabledColor
            customPrimaryButtonDisabledColor = CustomColorConstants.bluesPrimaryButtonDisabledColor
            customSecondaryButtonColor = CustomColorConstants.bluesSecondaryButtonColor
            customPrimaryStrokeColor = CustomColorConstants.bluesMeterViewStrokeColor
            customOuterLayerFillColor = CustomColorConstants.bluesKnobOuterLayerFillColor
            customOuterLayerStrokeColor = CustomColorConstants.bluesKnobOuterLayerStrokeColor
            customMiddleLayer1FillColor = CustomColorConstants.bluesKnobMiddleLayer1FillColor
            customMiddleLayer2FillColor = CustomColorConstants.bluesKnobMiddleLayer2FillColor
            customPointerLayerStrokeColor = CustomColorConstants.bluesKnobPointerLayerStrokeColor
        case colorData[1]:
            customPrimaryButtonEnabledColor = CustomColorConstants.pinksPrimaryButtonEnabledColor
            customPrimaryButtonDisabledColor = CustomColorConstants.pinksPrimaryButtonDisabledColor
            customSecondaryButtonColor = CustomColorConstants.pinksSecondaryButtonColor
            customPrimaryStrokeColor = CustomColorConstants.pinksMeterViewStrokeColor
            customOuterLayerFillColor = CustomColorConstants.pinksKnobOuterLayerFillColor
            customOuterLayerStrokeColor = CustomColorConstants.pinksKnobOuterLayerStrokeColor
            customMiddleLayer1FillColor = CustomColorConstants.pinksKnobMiddleLayer1FillColor
            customMiddleLayer2FillColor = CustomColorConstants.pinksKnobMiddleLayer2FillColor
            customPointerLayerStrokeColor = CustomColorConstants.pinksKnobPointerLayerStrokeColor
        case colorData[2]:
            customPrimaryButtonEnabledColor = CustomColorConstants.purplesPrimaryButtonEnabledColor
            customPrimaryButtonDisabledColor = CustomColorConstants.purplesPrimaryButtonDisabledColor
            customSecondaryButtonColor = CustomColorConstants.purplesSecondaryButtonColor
            customPrimaryStrokeColor = CustomColorConstants.purplesMeterViewStrokeColor
            customOuterLayerFillColor = CustomColorConstants.purplesKnobOuterLayerFillColor
            customOuterLayerStrokeColor = CustomColorConstants.purplesKnobOuterLayerStrokeColor
            customMiddleLayer1FillColor = CustomColorConstants.purplesKnobMiddleLayer1FillColor
            customMiddleLayer2FillColor = CustomColorConstants.purplesKnobMiddleLayer2FillColor
            customPointerLayerStrokeColor = CustomColorConstants.purplesKnobPointerLayerStrokeColor
        default:
            customPrimaryButtonEnabledColor = CustomColorConstants.bluesPrimaryButtonEnabledColor
            customPrimaryButtonDisabledColor = CustomColorConstants.bluesPrimaryButtonDisabledColor
            customSecondaryButtonColor = CustomColorConstants.bluesSecondaryButtonColor
            customPrimaryStrokeColor = CustomColorConstants.bluesMeterViewStrokeColor
            customOuterLayerFillColor = CustomColorConstants.bluesKnobOuterLayerFillColor
            customOuterLayerStrokeColor = CustomColorConstants.bluesKnobOuterLayerStrokeColor
            customMiddleLayer1FillColor = CustomColorConstants.bluesKnobMiddleLayer1FillColor
            customMiddleLayer2FillColor = CustomColorConstants.bluesKnobMiddleLayer2FillColor
            customPointerLayerStrokeColor = CustomColorConstants.bluesKnobPointerLayerStrokeColor
        }
        startStopButton.backgroundColor = customPrimaryButtonDisabledColor
        tapButton.backgroundColor = customPrimaryButtonDisabledColor
        decBPMButton.backgroundColor = customPrimaryButtonDisabledColor
        incBPMButton.backgroundColor = customPrimaryButtonDisabledColor
        tapView.backgroundColor = customSecondaryButtonColor
        myMeterView.accentViewColor = customPrimaryButtonEnabledColor
        myMeterView.normalViewColor = customPrimaryButtonDisabledColor
        myMeterView.strokeViewColor = customPrimaryStrokeColor
        
        knob.outerLayerFillColor =  customOuterLayerFillColor
        knob.outerLayerStrokeColor = customOuterLayerStrokeColor
        knob.middleLayer1FillColor = customMiddleLayer1FillColor
        knob.middleLayer2FillColor = customMiddleLayer2FillColor
        knob.pointerLayerStrokeColor = customPointerLayerStrokeColor
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
