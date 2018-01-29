//
//  TabYenBasisViewController.swift
//  FX_margin3
//

import UIKit

class TabYenBasisViewController: FXMarginViewController {

    // MARK: - private variable
    private var firstAppear: Bool = false

    // MARK: - IBOutlet
    @IBOutlet weak var outletMainContentsView: UIView!

    @IBOutlet weak var outletYenRateValueTextField: YenRateValueTextField!
    @IBOutlet weak var outletLeverageValueTextField: LeverageValueTextField!
    @IBOutlet weak var outletLotsValueTextField: XINumberTextFieldWithToolbar!
    @IBOutlet weak var outletBalanceValueTextField: XINumberTextFieldWithToolbar!
    @IBOutlet weak var outletLossCutMarginValueTextField: XINumberTextFieldWithToolbar!
    @IBOutlet weak var outletTradeTypeTextField: TradeTypePickerTextField!

    @IBOutlet weak var outletMarginValueLabel: XIPaddingLabel!
    @IBOutlet weak var outletLossCutRateValueLabel: XIPaddingLabel!
    @IBOutlet weak var outletLossCutLossValueLabel: XIPaddingLabel!

    // MARK: - override for FXMarginViewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 最初に表示される時の処理
        if (firstAppear != true) {
            outletMainContentsView.isHidden = true  // メインコンテンツの準備ができるまで非表示
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 最初に表示される時の処理
        if (firstAppear != true) {
            outletMainContentsView.isHidden = false // メインコンテンツの準備が完了したので表示
            firstAppear = true
        }
    }
    
    @objc override func textFieldEditingChanged(sender: UITextField) {
        
        // 入力値を取得
        let decRate = outletYenRateValueTextField.GetDecimalValue()
        let decLeverage = outletLeverageValueTextField.GetDecimalValue()
        let decLots = outletLotsValueTextField.GetDecimalValue() * 10000    // Convert to １万通貨
        let decBalance = outletBalanceValueTextField.GetDecimalValue()
        let decLossCutMargin = outletLossCutMarginValueTextField.GetDecimalValue() / 100  // % to calculation value
        let decTradeType = outletTradeTypeTextField.GetDecimalValue()
       
        
        // 必要証拠金 = (現在レート * ロット数) / レバレッジ
        let decMargin: Decimal?
        if ( decLeverage != 0 ) {
           decMargin = (decRate * decLots) / decLeverage
        }
        else {
           decMargin = nil
        }
        outletMarginValueLabel.text = decMargin?.description
        outletMarginValueLabel.FontSizeToFit()
        
        if ( decMargin != nil && decLots != 0 ) {
            
            // ロスカットレート = 現在レート - (((口座残高 - (必要証拠金 * ロスカット維持率)) / ロット数) * 売り[-1]or買い[1])
            let decLossCutMargin = ((decBalance - (decMargin! * decLossCutMargin)) / decLots) * decTradeType
            let decLossCutRate = decRate - decLossCutMargin
            outletLossCutRateValueLabel.text = decLossCutRate.description
            outletLossCutRateValueLabel.FontSizeToFit()
            
            // ロスカット損失 = ABS(ロスカットレート) * ロット数
            let decLossCutLoss = abs(decLossCutMargin) * decLots
            outletLossCutLossValueLabel.text = decLossCutLoss.description
            outletLossCutLossValueLabel.FontSizeToFit()
            
        }
        else {
            outletLossCutRateValueLabel.text = ""
            outletLossCutLossValueLabel.text = ""
        }
    }
}
