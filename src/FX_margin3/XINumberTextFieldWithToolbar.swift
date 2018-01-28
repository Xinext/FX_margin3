//
//  XIToolbarTextField.swift
//  FX_margin3
//

import UIKit

class XINumberTextFieldWithToolbar: UITextField {

    // MARK: - Const value
    private let PADDING_SIZE: CGFloat = 5.0
    
    // MARK: - Private variable
    private var _buttonArray: [UIBarButtonItem] = []    // for toolbar
    
    // MARK: - Protocol
    var isDecimalConvert: Bool {
        get {
            if (self.text?.isEmpty == true) { return true }     // 空白はOKとする
            guard let _ = Decimal(string: self.text!) else { return false } // 変換チェック
            return true
        }
    }
    
    // MARK: - @IBInspectable
    @IBInspectable var DecimalPoint: Bool = false {
        didSet {
            if (DecimalPoint == true) {
                self.keyboardType = .decimalPad
            }
            else {
                self.keyboardType = .numberPad
            }
        }
    }

    // MARK: - Initiallizer
    override init(frame: CGRect) {
        super.init(frame: frame)
        initConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initConfig()
    }
    
    // MARK: - method - initialization
    /**
     各種設定の初期化
     */
    private func initConfig() {
        
        // ツールバーの設定
        createToolbar()

        // 初期値の設定
        self.text = ""
    }
    
    /**
     ツールバーの生成
     */
    private func createToolbar() {
        
        // ボタンの生成
        createAdditionalButtonItems(&_buttonArray)
        createBaseButtonItems(&_buttonArray)
        
        // ツールバーの設定
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.setItems(_buttonArray, animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        self.inputAccessoryView = toolBar
    }
    
    // MARK: - method
    /**
     The method is for adding own buttons.
     (Override in subclass.)
     */
    open func createAdditionalButtonItems(_ buttonArray: inout [UIBarButtonItem] ) {
        /* Overrideして必要なボタンと処理を追加してください */
    }
    
    /**
     Add deault buuton to toolbar
     */
    private func createBaseButtonItems(_ buttonArray: inout [UIBarButtonItem] ) {
        
        let okButton   = UIBarButtonItem(title: "閉じる", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.okButtonPush))
        let spaceButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        buttonArray.append(spaceButton)
        buttonArray.append(okButton)
    }
    
    // MARK: - oerride
    /// 入力したテキストの余白
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: PADDING_SIZE, dy: PADDING_SIZE)
    }
    
    /// 編集中のテキストの余白
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: PADDING_SIZE, dy: PADDING_SIZE)
    }
    
    /// プレースホルダーの余白
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: PADDING_SIZE, dy: PADDING_SIZE)
    }

    // MARK: - Button action for toolbar
    /// OK button
    @objc func okButtonPush() {
        // 数値チェック
        let decValue = Decimal(string: self.text!)
        self.text = decValue?.description
        
        // キーボードを閉じる
        self.superview?.endEditing(true)
    }
    
    // MARK: - Public method
    /// Get value in Decimal type
    /// - Returns: Dedimal type value
    func GetDecimalValue() -> Decimal {
        
        let decValue = Decimal(string: self.text!)
        
        var resValue: Decimal = 0
        if decValue != nil {
            resValue = decValue!
        }
        else {
            resValue = 0
        }
        
        return resValue
    }
}
