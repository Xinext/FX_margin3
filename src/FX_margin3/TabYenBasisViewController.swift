//
//  TabYenBasisViewController.swift
//  FX_margin3
//

import UIKit

class TabYenBasisViewController: MainContentsViewController {

    // MARK: - private variable
    private var firstAppear: Bool = false

    // MARK: - IBOutlet
    @IBOutlet weak var outletMainContentsView: UIView!

    @IBOutlet weak var outletCurrentRateValueTextField: YenRateValueTextField!
    @IBOutlet weak var outletLeverageValueTextField: LeverageValueTextField!
    @IBOutlet weak var outletLotsValueTextField: XINumberTextFieldWithToolbar!
    @IBOutlet weak var outletBalanceValueTextField: XINumberTextFieldWithToolbar!
    @IBOutlet weak var outletLCMarginRatioValueTextField: XINumberTextFieldWithToolbar!
    @IBOutlet weak var outletTradeTypeTextField: TradeTypePickerTextField!

    @IBOutlet weak var outletInitialMarginValueLabel: XIPaddingLabel!
    @IBOutlet weak var outletLCRateValueLabel: XIPaddingLabel!
    @IBOutlet weak var outletLCLossValueLabel: XIPaddingLabel!

    // MARK: - override for MainContentsViewController
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
        
        let margin = calcInitialMargin()
        let lsm = calcLossCutMargin()
        let lcrate = lsm.rate
        let lcloss = lsm.loss

        setterResultTextFields(margin: margin, lcrate: lcrate, lcloss: lcloss)
    }
    
    // MARK: - private method
    /// 必要証拠金の計算
    private func calcInitialMargin() -> Decimal? {
        
        // 計算に必要な値を取得
        guard let decCurrentRate = outletCurrentRateValueTextField.GetDecimalValue() else { return nil }
        guard let decLeverage = outletLeverageValueTextField.GetDecimalValue() else { return nil }
        guard let wkLots = outletLotsValueTextField.GetDecimalValue() else { return nil }
        let decLots = wkLots * 10000    // Convert to １万通貨
        
        // 必要証拠金 = (現在レート * ロット数) / レバレッジ
        let decInitialMargin = ((decCurrentRate * decLots) / decLeverage).rounded(0, roundingMode: .up)    // 必要証拠金は円単位で切り上げ

        return decInitialMargin
    }
    
    /// ロスカットまで金額の計算
    private func calcLossCutMargin() -> (range: Decimal?, rate: Decimal?, loss: Decimal?) {
        
        // 計算に必要な値を取得
        guard let decCurrentRate = outletCurrentRateValueTextField.GetDecimalValue() else { return(nil,nil,nil) }
        guard let decInitialMargin = calcInitialMargin() else { return(nil,nil,nil) }
        guard let wkLots = outletLotsValueTextField.GetDecimalValue() else { return(nil,nil,nil) }
        let decLots = wkLots * 10000    // Convert to １万通貨
        guard let decBalance = outletBalanceValueTextField.GetDecimalValue() else { return(nil,nil,nil) }
        guard let decLCMarginRatio = outletLCMarginRatioValueTextField.GetDecimalValue() else { return(nil,nil,nil) }
        let decTradeType = outletTradeTypeTextField.GetDecimalValue()
        
        // 口座残高チェック
        if ( decInitialMargin > decBalance ) {    // 口座残高が必要証拠金より少ない場合は即時ロスカット扱いにする
            return( nil, decCurrentRate, decBalance )
        }
        
        // 各値の計算
        let decLCRange = ((decBalance - ( decInitialMargin * (decLCMarginRatio / 100) )) / decLots) * decTradeType  // ロスカまでの値幅
        let decLCRate = (decCurrentRate - decLCRange).rounded(3, roundingMode: .down)        // ロスカット時のレート (小数点第３以下切り捨て)
        let decLCLoss = (abs(decLCRange) * decLots).rounded(0, roundingMode: .up)     // ロスカット時の損失
        
        return (decLCRange, decLCRate, decLCLoss)
    }
    
    /// [setter]計算結果の表示
    private func setterResultTextFields( margin: Decimal?, lcrate: Decimal?, lcloss: Decimal? ) {
        
        // 必要証拠金
        if (margin != nil) {
            outletInitialMarginValueLabel.text = margin!.description
        }
        else {
            outletInitialMarginValueLabel.text = ""
        }
        outletInitialMarginValueLabel.FontSizeToFit()
        
        // ロスカットレート
        if ( lcrate != nil ) {
            outletLCRateValueLabel.text = lcrate!.description
        }
        else {
            outletLCRateValueLabel.text = ""
        }
        outletLCRateValueLabel.FontSizeToFit()
        
        // ロスカット損失
        if ( lcloss != nil ) {
            outletLCLossValueLabel.text = lcloss!.description
        }
        else {
            outletLCLossValueLabel.text = ""
        }
        outletLCLossValueLabel.FontSizeToFit()
        
    }
    
}
