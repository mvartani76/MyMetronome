//
//  SettingsViewController.swift
//  MyMetronome
//
//  Created by Michael Vartanian on 7/5/19.
//  Copyright © 2019 Michael Vartanian. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Font/Color Picker Data
    var fontData = ["Ember", "Grinched", "PartyLetPlain", "GooddogPlain"]
    var colorData = ["Blues", "Pinks", "Purples", "Greens"]
 
    var customFont: String = ""
    var customColorScheme: String = ""
    
    @IBOutlet var fontPickerView: UIPickerView!
    @IBOutlet var colorPickerView: UIPickerView!
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var fontLabel: UILabel!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var resetMetroLabel: UILabel!
    @IBOutlet var resetMetroSwitch: UISwitch!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if pickerView == fontPickerView {
            return fontData.count
        }
        else {
            return colorData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if pickerView == fontPickerView {
            return fontData[row]
        }
        else {
            return colorData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == fontPickerView {
            customFont = fontData[row]
            UserDefaults.standard.set(customFont, forKey: "font")
            updateSettingsFonts(customFontType: customFont)
        }
        else {
            customColorScheme = colorData[row]
            UserDefaults.standard.set(customColorScheme, forKey: "colorScheme")
        }
        // Need to reload the components to get the font change to take effect
        fontPickerView.reloadAllComponents()
        colorPickerView.reloadAllComponents()
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

        if pickerView == fontPickerView {
            label.text = fontData[row]
        } else {
            label.text = colorData[row]
        }

        return label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Connect data:
        self.fontPickerView.delegate = self
        self.fontPickerView.dataSource = self
        self.colorPickerView.delegate = self
        self.colorPickerView.dataSource = self
        
        customFont = fontData[0]
        customColorScheme = colorData[0]

        resetMetroSwitch.addTarget(self, action: #selector(resetMetroChanged), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customFont = UserDefaults.standard.string(forKey: "font") ?? fontData[0]
        customColorScheme = UserDefaults.standard.string(forKey: "colorScheme") ?? colorData[0]
        let resetMetroSwitchState = UserDefaults.standard.bool(forKey: "resetMetroState") 
        resetMetroSwitch.setOn(resetMetroSwitchState, animated: false)
        updateSettingsFonts(customFontType: customFont)
        updateSettingsColors(customColorType: customColorScheme)

        // Update picker positions to previously selected/stored value
        let fontIndex = fontData.firstIndex(of: customFont) ?? 0
        let colorIndex = colorData.firstIndex(of: customColorScheme) ?? 0

        fontPickerView.selectRow(fontIndex, inComponent: 0, animated: true)
        colorPickerView.selectRow(colorIndex, inComponent: 0, animated: true)
    }
    
    public func updateSettingsFonts(customFontType: String) {
        var customFontTitleSizeVar: CGFloat
        var customFontLabelSizeVar: CGFloat
        var customColorLabelSizeVar: CGFloat
        var customResetMetroLabelSizeVar: CGFloat
        
        switch customFontType {
        case fontData[0]:
            customFontTitleSizeVar = CustomFontConstants.emberFontTitleSize
            customFontLabelSizeVar = CustomFontConstants.emberFontLabelSize
            customColorLabelSizeVar = CustomFontConstants.emberColorLabelSize
            customResetMetroLabelSizeVar = CustomFontConstants.emberResetMetroLabelSize
        case fontData[1]:
            customFontTitleSizeVar = CustomFontConstants.grinchedFontTitleSize
            customFontLabelSizeVar = CustomFontConstants.grinchedFontLabelSize
            customColorLabelSizeVar = CustomFontConstants.grinchedColorLabelSize
            customResetMetroLabelSizeVar = CustomFontConstants.grinchedResetMetroLabelSize
        case fontData[2]:
            customFontTitleSizeVar = CustomFontConstants.partyPlainFontTitleSize
            customFontLabelSizeVar = CustomFontConstants.partyPlainFontLabelSize
            customColorLabelSizeVar = CustomFontConstants.partyPlainColorLabelSize
            customResetMetroLabelSizeVar = CustomFontConstants.partyPlainResetMetroLabelSize
        case fontData[3]:
            customFontTitleSizeVar = CustomFontConstants.gooddogFontTitleSize
            customFontLabelSizeVar = CustomFontConstants.gooddogFontLabelSize
            customColorLabelSizeVar = CustomFontConstants.gooddogColorLabelSize
            customResetMetroLabelSizeVar = CustomFontConstants.gooddogResetMetroLabelSize
        default:
            customFontTitleSizeVar = CustomFontConstants.emberFontTitleSize
            customFontLabelSizeVar = CustomFontConstants.emberFontLabelSize
            customColorLabelSizeVar = CustomFontConstants.emberColorLabelSize
            customResetMetroLabelSizeVar = CustomFontConstants.emberResetMetroLabelSize
        }

        topLabel.font = UIFont(name: customFont, size: customFontTitleSizeVar)
        fontLabel.font = UIFont(name: customFont, size: customFontLabelSizeVar)
        colorLabel.font = UIFont(name: customFont, size: customColorLabelSizeVar)
        resetMetroLabel.font = UIFont(name: customFont, size: customResetMetroLabelSizeVar)
    }

    public func updateSettingsColors(customColorType: String) {

    }

    @objc func resetMetroChanged(switchState: UISwitch) {
        if switchState.isOn {
            UserDefaults.standard.set(true, forKey: "resetMetroState")
        }
        else {
            UserDefaults.standard.set(false, forKey: "resetMetroState")
        }
    }


}

