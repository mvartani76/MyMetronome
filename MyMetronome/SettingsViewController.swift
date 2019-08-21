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
    
    // Input the data into the array
    var fontData = ["Ember", "Grinched", "PartyLetPlain", "GooddogPlain"]
    
    @IBOutlet var fontPickerView: UIPickerView!
    @IBOutlet var fontLabel: UILabel!
    @IBOutlet var topLabel: UILabel!
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fontData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fontData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        customFont = fontData[row]
        UserDefaults.standard.set(customFont, forKey: "font")
        updateSettingsFonts(customFontType: customFont)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Connect data:
        self.fontPickerView.delegate = self
        self.fontPickerView.dataSource = self
        
        customFont = "Ember"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customFont = UserDefaults.standard.string(forKey: "font") ?? "Ember"
        updateSettingsFonts(customFontType: customFont)
    }
    
    public func updateSettingsFonts(customFontType: String) {
        var customFontTitleSizeVar: CGFloat
        var customFontLabelSizeVar: CGFloat
        
        switch customFontType {
        case "Ember":
            customFontTitleSizeVar = CustomFontConstants.emberFontTitleSize
            customFontLabelSizeVar = CustomFontConstants.emberFontLabelSize
        case "Grinched":
            customFontTitleSizeVar = CustomFontConstants.grinchedFontTitleSize
            customFontLabelSizeVar = CustomFontConstants.grinchedFontLabelSize
        case "PartyLetPlain":
            customFontTitleSizeVar = CustomFontConstants.partyPlainFontTitleSize
            customFontLabelSizeVar = CustomFontConstants.partyPlainFontLabelSize
        case "GooddogPlain":
            customFontTitleSizeVar = CustomFontConstants.gooddogFontTitleSize
            customFontLabelSizeVar = CustomFontConstants.gooddogFontLabelSize
        default:
            customFontTitleSizeVar = CustomFontConstants.emberFontTitleSize
            customFontLabelSizeVar = CustomFontConstants.emberFontLabelSize
        }

        topLabel.font = UIFont(name: customFont, size: customFontTitleSizeVar)
        fontLabel.font = UIFont(name: customFont, size: customFontLabelSizeVar)
    }


}

