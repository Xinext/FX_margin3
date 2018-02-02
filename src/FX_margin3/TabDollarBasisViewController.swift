//
//  TabDollarBasisViewController.swift
//  FX_margin3
//

import UIKit

class TabDollarBasisViewController: MainContentsViewController {
    
    // MARK: - private variable
    private var firstAppear: Bool = false
    
    // MARK: - IBOutlet
    @IBOutlet weak var outletMainContentsView: UIView!
    
    @IBOutlet weak var outletDollarRateValueTextField: DollarRateValueTextField!
    @IBOutlet weak var outletYenRateValueTextField: DollarYenRateValueTextField!
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
        let lcrate = lsm.dollarRate
        let lcloss = lsm.yenLoss
        
        setterResultTextFields(margin: margin.yen, lcrate: lcrate, lcloss: lcloss)
    }
    
    // MARK: - private method
    /// 必要証拠金の計算
    private func calcInitialMargin() -> ( dollar: Decimal?, yen: Decimal? ) {
        
        // 計算に必要な値を取得
        guard let decDollarRate = outletDollarRateValueTextField.GetDecimalValue() else { return (nil,nil) }
        guard let decYenRate = outletYenRateValueTextField.GetDecimalValue() else { return (nil,nil) }
        guard let decLeverage = outletLeverageValueTextField.GetDecimalValue() else { return (nil,nil) }
        guard let wkLots = outletLotsValueTextField.GetDecimalValue() else { return (nil,nil) }
        let decLots = wkLots * 10000    // Convert to １万通貨
        
        // 必要証拠金[$] = (ドルレート * ロット数) / レバレッジ
        let decDollarInitialMargin = ((decDollarRate  * decLots) / decLeverage).rounded(5, roundingMode: .up)    // 必要証拠金は第６位で切り上げ（小数点以下５位まで表示）
        // 必要証拠金[円]へ変換
        let decYenInitialMargin = (decDollarInitialMargin * decYenRate).rounded(0, roundingMode: .up)
        
        return (decDollarInitialMargin, decYenInitialMargin)
    }
    
    /// ロスカットまで金額の計算
    private func calcLossCutMargin() -> (dollarRange: Decimal?, dollarRate: Decimal?, yenRate: Decimal?, dollarLoss: Decimal?, yenLoss: Decimal?) {
        
        // 計算に必要な値を取得
        guard let decDollarRate = outletDollarRateValueTextField.GetDecimalValue() else { return(nil,nil,nil,nil,nil) }
        guard let decYenRate = outletYenRateValueTextField.GetDecimalValue() else { return (nil,nil,nil,nil,nil) }
        let decInitialMargin = calcInitialMargin()
        guard let decDollarInitialMargin = decInitialMargin.dollar else { return(nil,nil,nil,nil,nil) }
        guard let decYenInitialMargin = decInitialMargin.yen else { return(nil,nil,nil,nil,nil) }
        guard let wkLots = outletLotsValueTextField.GetDecimalValue() else { return(nil,nil,nil,nil,nil) }
        let decLots = wkLots * 10000    // Convert to １万通貨
        guard let decYenBalance = outletBalanceValueTextField.GetDecimalValue() else { return(nil,nil,nil,nil,nil) }
        let decDollarBalance = decYenBalance / decYenRate
        guard let decLCMarginRatio = outletLCMarginRatioValueTextField.GetDecimalValue() else { return(nil,nil,nil,nil,nil) }
        let decTradeType = outletTradeTypeTextField.GetDecimalValue()
        
        // 口座残高チェック
        if ( decDollarInitialMargin > decDollarBalance ) {    // 口座残高が必要証拠金より少ない場合は即時ロスカット扱いにする
            return( nil, decDollarInitialMargin, decYenInitialMargin, decDollarBalance, decYenBalance )
        }
        
        // 各値の計算
        let decDollarLCRange = ((decDollarBalance - ( decDollarInitialMargin * (decLCMarginRatio / 100) )) / decLots) * decTradeType  // [ドル建] ロスカまでの値幅
        let decDollarLCRate = (decDollarRate - decDollarLCRange).rounded(5, roundingMode: .down)        // [ドル建] ロスカット時のレート (小数点第５以下切り捨て)
        let decDollarLCLoss = (abs(decDollarLCRange) * decLots).rounded(5, roundingMode: .up)           // [ドル建] ロスカット時の損失
        
        let decYenLCRate = (decDollarLCRate * decYenRate).rounded(0, roundingMode: .down)       // [円建] ロスカット時のレート (小数点以下切り捨て)
        let decYenLCLoss = (decDollarLCLoss * decYenRate).rounded(0, roundingMode: .up)         // [円建] ロスカット時の損失
        
        
        return (decDollarLCRange, decDollarLCRate, decYenLCRate, decDollarLCLoss, decYenLCLoss)
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






