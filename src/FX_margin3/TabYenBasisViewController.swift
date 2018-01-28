//
//  TabYenBasisViewController.swift
//  FX_margin3
//

import UIKit

class TabYenBasisViewController: XIViewController {

    // MARK: - const value
    private let TRADETYPE_SHORT: Int = 0
    private let TRADETYPE_LONG: Int = 1

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

    // MARK: - override
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 各種初期化
        initConfig()
    }

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
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        adjustFontSizeOfTextFilds()
    }

    /// 各TextFieldが変更された時の処理
    ///
    /// - Parameters:
    ///   - sender: 該当のコントロール
    @objc func textFieldEditingChanged(sender: UITextField) {
        
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
    
    // MARK: - configuration
    /// 各種設定の初期化
    func initConfig() {
        initConfig_textField()
    }
    
    // (sub)TextFieldの初期化
    func initConfig_textField() {
        
        let tfArray = getTextfields(view: self.view)
        for tf in tfArray {
            tf.delegate = self
            if tf == outletTradeTypeTextField {
                 tf.addTarget(self, action: #selector(self.textFieldEditingChanged(sender:)), for: .editingDidEnd)
            }
            else {
                tf.text = ""
                tf.addTarget(self, action: #selector(self.textFieldEditingChanged(sender:)), for: .editingChanged)
            }
        }
    }
    
    // MARK: - method
    /// Viewに追加されているUITextFieldを検索して全て取得
    ///
    /// - Parameters:
    ///   - view: 対象View
    /// - Returns: UITextFieldの配列
    func getTextfields(view: UIView) -> [UITextField] {
        
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                results += [textField]
            } else {
                results += getTextfields(view: subview)
            }
        }
        return results
    }
    
    /// TextFieldのフォントサイズ最適化
    func adjustFontSizeOfTextFilds() {
        
        let allTextFields = getTextfields(view: self.view)
        for textField in allTextFields
        {
            textField.font = UIFont.boldSystemFont(ofSize: 46)
            var widthOfText: CGFloat = textField.text!.size(withAttributes: [NSAttributedStringKey.font: textField.font!]).width
            let widthOfFrame: CGFloat = textField.frame.size.width
            
            var heightOfText: CGFloat = textField.text!.size(withAttributes: [NSAttributedStringKey.font: textField.font!]).height
            let heightOfFrame: CGFloat = textField.frame.size.height
            
            while ((widthOfFrame - 15) < widthOfText) || ((heightOfFrame - 10) < heightOfText) {
                let fontSize: CGFloat = textField.font!.pointSize
                textField.font = textField.font?.withSize(CGFloat(fontSize - 0.5))
                widthOfText = (textField.text?.size(withAttributes: [NSAttributedStringKey.font: textField.font!]).width)!
                heightOfText = (textField.text?.size(withAttributes: [NSAttributedStringKey.font: textField.font!]).height)!
            }
        }
    }
}
