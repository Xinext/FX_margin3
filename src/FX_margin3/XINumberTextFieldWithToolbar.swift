//
//  XIToolbarTextField.swift
//  FX_margin3
//

import UIKit

class XINumberTextFieldWithToolbar: UITextField {

    
    //入力したテキストの余白
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 5.0, dy: 5.0)
    }
    
    //編集中のテキストの余白
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 5.0, dy: 5.0)
    }
    
    //プレースホルダーの余白
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 5.0, dy: 5.0)
    }
    
    
    
    // MARK: - @IBInspectable
    @IBInspectable var DecimalPoint: Bool = false {
        didSet {
            // キーボードの選択
            if (DecimalPoint == true) {
                self.keyboardType = .decimalPad
            }
            else {
                self.keyboardType = .numberPad
            }
        }
    }
    
    // MARK: - Private variable
    private var _buttonArray: [UIBarButtonItem] = []
    
    // MARK: - Initiallizer
    override init(frame: CGRect) {
        super.init(frame: frame)
        initConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initConfig()
    }
    
    /**
     各種設定の初期化
     */
    private func initConfig() {
        
        // ツールバーの設定
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        
        createAdditionalButtonItems(&_buttonArray)
        createBaseButtonItems(&_buttonArray)
        
        toolBar.setItems(_buttonArray, animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        self.inputAccessoryView = toolBar
        
        // 初期値の設定
        self.text = ""
    }
    
    open func createAdditionalButtonItems(_ buttonArray: inout [UIBarButtonItem] ) {
        
    }
    
    private func createBaseButtonItems(_ buttonArray: inout [UIBarButtonItem] ) {
        
        let okButton   = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.donePressed))
        let spaceButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        buttonArray.append(spaceButton)
        buttonArray.append(okButton)
        
    }
    
    // Done
    @objc func donePressed() {
        
        self.superview?.endEditing(true)
    }
    
    // Cancel
    @objc func cancelPressed() {
        self.text = ""
        self.superview?.endEditing(true)
    }
    
}
