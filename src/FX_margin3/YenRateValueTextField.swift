//
//  YenRateTextField.swift
//  FX_margin3
//

import UIKit

class YenRateValueTextField: XINumberTextFieldWithToolbar {

    let MSG_FAIL_GETRATE = NSLocalizedString("MSG_ERR_GETRATE", comment: "Failed get rate.")
    
    override func createAdditionalButtonItems(_ buttonArray: inout [UIBarButtonItem]) {
        
        let usdButton = UIBarButtonItem(title: "USD", style: .plain, target: self, action: #selector(self.USDButton_TouchDown(sender:)))
        usdButton.tintColor = UIColor.red
        buttonArray.append(usdButton)
        
        let eurButton = UIBarButtonItem(title: "EUR", style: .plain, target: self, action: #selector(self.EURButton_TouchDown(sender:)))
        eurButton.tintColor = UIColor.red
        buttonArray.append(eurButton)

        let gbpButton = UIBarButtonItem(title: "GBP", style: .plain, target: self, action: #selector(self.GBPButton_TouchDown(sender:)))
        gbpButton.tintColor = UIColor.red
        buttonArray.append(gbpButton)
        
        let audButton = UIBarButtonItem(title: "AUD", style: .plain, target: self, action: #selector(self.AUDButton_TouchDown(sender:)))
        audButton.tintColor = UIColor.red
        buttonArray.append(audButton)
        
        let nzdButton = UIBarButtonItem(title: "NZD", style: .plain, target: self, action: #selector(self.NZDButton_TouchDown(sender:)))
        nzdButton.tintColor = UIColor.red
        buttonArray.append(nzdButton)
    }
    
    /**
     [Callback] USDボタン 押下
     */
    @objc internal func USDButton_TouchDown(sender: UIBarButtonItem){
        
        let rate = CurrencyRateUtility.GetCrossYenRate(pair: .USD)
        if rate != nil {
            self.text = rate?.description
        }
        else {
            XIDialog.DispAlertMsg(pvc: self.parentViewController()!, msg: MSG_FAIL_GETRATE)
        }
    }

    /**
     [Callback] EURボタン 押下
     */
    @objc internal func EURButton_TouchDown(sender: UIBarButtonItem){
        
        let rate = CurrencyRateUtility.GetCrossYenRate(pair: .EUR)
        if rate != nil {
            self.text = rate?.description
        }
        else {
            XIDialog.DispAlertMsg(pvc: self.parentViewController()!, msg: MSG_FAIL_GETRATE)
        }
    }

    /**
     [Callback] GBPボタン 押下
     */
    @objc internal func GBPButton_TouchDown(sender: UIBarButtonItem){

        let rate = CurrencyRateUtility.GetCrossYenRate(pair: .GBP)
        if rate != nil {
            self.text = rate?.description
        }
        else {
            XIDialog.DispAlertMsg(pvc: self.parentViewController()!, msg: MSG_FAIL_GETRATE)
        }
    }

    /**
     [Callback] AUDボタン 押下
     */
    @objc internal func AUDButton_TouchDown(sender: UIBarButtonItem){

        let rate = CurrencyRateUtility.GetCrossYenRate(pair: .AUD)
        if rate != nil {
            self.text = rate?.description
        }
        else {
            XIDialog.DispAlertMsg(pvc: self.parentViewController()!, msg: MSG_FAIL_GETRATE)
        }
    }

    /**
     [Callback] NZDボタン 押下
     */
    @objc internal func NZDButton_TouchDown(sender: UIBarButtonItem){

        let rate = CurrencyRateUtility.GetCrossYenRate(pair: .NZD)
        if rate != nil {
            self.text = rate?.description
        }
        else {
            XIDialog.DispAlertMsg(pvc: self.parentViewController()!, msg: MSG_FAIL_GETRATE)
        }
    }
 
}
