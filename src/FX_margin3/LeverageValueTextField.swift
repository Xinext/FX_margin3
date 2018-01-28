// 
// FX_margin3
// LeverageValueTextField.swift
//

import UIKit

class LeverageValueTextField: XINumberTextFieldWithToolbar {

    override func createAdditionalButtonItems(_ buttonArray: inout [UIBarButtonItem]) {
        
        let p1Button = UIBarButtonItem(title: "1倍", style: .plain, target: self, action: #selector(self.p1Button_TouchDown(sender:)))
        p1Button.tintColor = UIColor.red
        buttonArray.append(p1Button)
        
        let p25Button = UIBarButtonItem(title: "25倍", style: .plain, target: self, action: #selector(self.p25Button_TouchDown(sender:)))
        p25Button.tintColor = UIColor.red
        buttonArray.append(p25Button)
        
        let p500Button = UIBarButtonItem(title: "500倍", style: .plain, target: self, action: #selector(self.p500Button_TouchDown(sender:)))
        p500Button.tintColor = UIColor.red
        buttonArray.append(p500Button)
        
        let gbpButton = UIBarButtonItem(title: "888倍", style: .plain, target: self, action: #selector(self.p888Button_TouchDown(sender:)))
        gbpButton.tintColor = UIColor.red
        buttonArray.append(p500Button)
    }
    
    /**
     [Callback] 1倍ボタン 押下
     */
    @objc internal func p1Button_TouchDown(sender: UIBarButtonItem){
        self.text = "1"
    }
    
    /**
     [Callback] 25倍ボタン 押下
     */
    @objc internal func p25Button_TouchDown(sender: UIBarButtonItem){
        self.text = "25"
    }
    
    /**
     [Callback] 500倍ボタン 押下
     */
    @objc internal func p500Button_TouchDown(sender: UIBarButtonItem){
        self.text = "500"
    }
    
    /**
     [Callback] 888倍ボタン 押下
     */
    @objc internal func p888Button_TouchDown(sender: UIBarButtonItem){
        self.text = "888"
    }
}
