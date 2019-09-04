//
//  SettingsViewController.swift
//  MyMetronome
//
//  Created by Michael Vartanian on 7/5/19.
//  Copyright © 2019 Michael Vartanian. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var customFont: String = "Ember"
    var customColorScheme: String = "Blues"
    
    // Font Picker Data
    var fontData = ["Ember", "Grinched", "PartyLetPlain", "GooddogPlain"]
    var colorData = ["Blues", "Pinks", "Purples", "Greens"]
    
    @IBOutlet var fontPickerView: UIPickerView!
    @IBOutlet var colorPickerView: UIPickerView!
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var fontLabel: UILabel!
    @IBOutlet var topLabel: UILabel!
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Connect data:
        self.fontPickerView.delegate = self
        self.fontPickerView.dataSource = self
        self.colorPickerView.delegate = self
        self.colorPickerView.dataSource = self
        
        customFont = "Ember"
        customColorScheme = "Blues"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customFont = UserDefaults.standard.string(forKey: "font") ?? "Ember"
        customColorScheme = UserDefaults.standard.string(forKey: "color") ?? "Blues"
        updateSettingsFonts(customFontType: customFont)
        updateSettingsColors(customColorType: customColorScheme)
    }
    
    public func updateSettingsFonts(customFontType: String) {
        var customFontTitleSizeVar: CGFloat
        var customFontLabelSizeVar: CGFloat
        var customColorLabelSizeVar: CGFloat
        
        switch customFontType {
        case "Ember":
            customFontTitleSizeVar = CustomFontConstants.emberFontTitleSize
            customFontLabelSizeVar = CustomFontConstants.emberFontLabelSize
            customColorLabelSizeVar = CustomFontConstants.emberColorLabelSize
        case "Grinched":
            customFontTitleSizeVar = CustomFontConstants.grinchedFontTitleSize
            customFontLabelSizeVar = CustomFontConstants.grinchedFontLabelSize
            customColorLabelSizeVar = CustomFontConstants.grinchedColorLabelSize
        case "PartyLetPlain":
            customFontTitleSizeVar = CustomFontConstants.partyPlainFontTitleSize
            customFontLabelSizeVar = CustomFontConstants.partyPlainFontLabelSize
            customColorLabelSizeVar = CustomFontConstants.partyPlainColorLabelSize
        case "GooddogPlain":
            customFontTitleSizeVar = CustomFontConstants.gooddogFontTitleSize
            customFontLabelSizeVar = CustomFontConstants.gooddogFontLabelSize
            customColorLabelSizeVar = CustomFontConstants.gooddogColorLabelSize
        default:
            customFontTitleSizeVar = CustomFontConstants.emberFontTitleSize
            customFontLabelSizeVar = CustomFontConstants.emberFontLabelSize
            customColorLabelSizeVar = CustomFontConstants.emberColorLabelSize
        }

        topLabel.font = UIFont(name: customFont, size: customFontTitleSizeVar)
        fontLabel.font = UIFont(name: customFont, size: customFontLabelSizeVar)
        colorLabel.font = UIFont(name: customFont, size: customColorLabelSizeVar)
    }

    public func updateSettingsColors(customColorType: String) {

    }


}

