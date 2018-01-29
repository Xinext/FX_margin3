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
        
        let margin = calcMaginMoney()
        let lsm = calcLossCutMargin()
        let lcrate = lsm.rate
        let lcloss = lsm.loss

        setterResultTextFields(margin: margin, lcrate: lcrate, lcloss: lcloss)
    }
    
    // MARK: - private method
    /// 必要証拠金の計算
    private func calcMaginMoney() -> Decimal? {
        
        // 計算に必要な値を取得
        guard let decRate = outletYenRateValueTextField.GetDecimalValue() else { return nil }
        guard let decLeverage = outletLeverageValueTextField.GetDecimalValue() else { return nil }
        guard let wkLots = outletLotsValueTextField.GetDecimalValue() else { return nil }
        let decLots = wkLots * 10000    // Convert to １万通貨
        
        // 必要証拠金 = (現在レート * ロット数) / レバレッジ
        let decMargin = ((decRate * decLots) / decLeverage).rounded(0, roundingMode: .up)    // 必要証拠金は円単位で切り上げ

        return decMargin
    }
    
    /// ロスカットまで金額の計算
    private func calcLossCutMargin() -> (range: Decimal?, rate: Decimal?, loss: Decimal?) {
        
        // 計算に必要な値を取得
        guard let decRate = outletYenRateValueTextField.GetDecimalValue() else { return(nil,nil,nil) }
        guard let decMarginMoney = calcMaginMoney() else { return(nil,nil,nil) }
        guard let wkLots = outletLotsValueTextField.GetDecimalValue() else { return(nil,nil,nil) }
        let decLots = wkLots * 10000    // Convert to １万通貨
        guard let decBalance = outletBalanceValueTextField.GetDecimalValue() else { return(nil,nil,nil) }
        guard let decLossCutMarginRatio = outletLossCutMarginValueTextField.GetDecimalValue() else { return(nil,nil,nil) }
        let decTradeType = outletTradeTypeTextField.GetDecimalValue()
        
        // 口座残高チェック
        if ( decMarginMoney > decBalance ) {    // 口座残高が必要証拠金より少ない場合は即時ロスカット扱いにする
            return( nil, decRate, decBalance )
        }
        
        // 各値の計算
        let decLossCutRange = ((decBalance - ( decMarginMoney * (decLossCutMarginRatio / 100) )) / decLots) * decTradeType  // ロスカまでの値幅
        let decLossCutRate = (decRate - decLossCutRange).rounded(3, roundingMode: .down)        // ロスカット時のレート (小数点第３以下切り捨て)
        let decLossCutLoss = (abs(decLossCutRange) * decLots).rounded(0, roundingMode: .up)     // ロスカット時の損失
        
        return (decLossCutRange, decLossCutRate, decLossCutLoss)
    }
    
    /// [setter]計算結果の表示
    private func setterResultTextFields( margin: Decimal?, lcrate: Decimal?, lcloss: Decimal? ) {
        
        // 必要証拠金
        if (margin != nil) {
            outletMarginValueLabel.text = margin!.description
        }
        else {
            outletMarginValueLabel.text = ""
        }
        outletMarginValueLabel.FontSizeToFit()
        
        // ロスカットレート
        if ( lcrate != nil ) {
            outletLossCutRateValueLabel.text = lcrate!.description
        }
        else {
            outletLossCutRateValueLabel.text = ""
        }
        outletLossCutRateValueLabel.FontSizeToFit()
        
        // ロスカット損失
        if ( lcloss != nil ) {
            outletLossCutLossValueLabel.text = lcloss!.description
        }
        else {
            outletLossCutLossValueLabel.text = ""
        }
        outletLossCutLossValueLabel.FontSizeToFit()
        
    }
    
}
