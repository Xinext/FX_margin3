// 
// FX_margin3
// DollarYenRateValueTextField.swift
//


import UIKit

class DollarYenRateValueTextField: XINumberTextFieldWithToolbar {
    
    // MARK: - constant value
    let MSG_FAIL_GETRATE = NSLocalizedString("MSG_ERR_GETRATE", comment: "エラー")
    
    // MARK: - override for XINumberTextFieldWithToolbar
    override func createAdditionalButtonItems(_ buttonArray: inout [UIBarButtonItem]) {
        
        let usdjpyButton = UIBarButtonItem(title: "USD/JPY", style: .plain, target: self, action: #selector(self.USDJPYButton_TouchDown(sender:)))
        usdjpyButton.tintColor = UIColor.red
        buttonArray.append(usdjpyButton)
    }
    
    // MARK: - callback
    /**
     USD/JPY"ボタン 押下
     */
    @objc private func USDJPYButton_TouchDown(sender: UIBarButtonItem){
        
        let rate = CurrencyRateUtility.GetCrossYenRate(pair: .USD)
        if rate != nil {
            self.text = rate?.description
        }
        else {
            XIDialog.DispAlertMsg(pvc: self.parentViewController()!,
                                  msg: MSG_FAIL_GETRATE)
        }
    }
    
    
}
