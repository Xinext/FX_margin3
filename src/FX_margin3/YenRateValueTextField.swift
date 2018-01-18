//
//  YenRateTextField.swift
//  FX_margin3
//

import UIKit

class YenRateValueTextField: XINumberTextFieldWithToolbar {

    override func createAdditionalButtonItems(_ buttonArray: inout [UIBarButtonItem]) {
        let usdButton = UIBarButtonItem(title: "USD", style: .plain, target: self, action: #selector(self.onClickMyButton(sender:)))
        buttonArray.append(usdButton)
        let eurButton = UIBarButtonItem(title: "EUR", style: .plain, target: self, action: #selector(self.onClickMyButton(sender:)))
        buttonArray.append(eurButton)

    }
    
    @objc internal func onClickMyButton(sender: UIBarButtonItem){
        // print(sender.title)
        
    }
}
