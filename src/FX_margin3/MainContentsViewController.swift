//
//  FXMarginViewController.swift
//  FX_margin3
//

import UIKit

class MainContentsViewController: UIViewController, UITextFieldDelegate  {

    // MARK: - const value
    let TRADETYPE_SHORT: Int = 0
    let TRADETYPE_LONG: Int = 1
    
    // MARK: - private variable
    private var txtActiveField = UITextField()

    // MARK: - override for UIViewControllerevent
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initConfig()    // 各種初期化
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObserver() // Notificationを画面が消えるときに削除
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        adjustFontSizeOfTextFilds()
    }
    
    // MARK: - configuration
    // 各種設定の初期化
    func initConfig() {
        initConfig_textField()
    }
    
    // TextFieldの初期化
    func initConfig_textField() {
        
        let tfArray = getTextfields(view: self.view)
        for tf in tfArray {
            
            tf.delegate = self
            tf.addTarget(self, action: #selector(self.textFieldEditingChanged(sender:)), for: .editingChanged)
            tf.addTarget(self, action: #selector(self.textFieldEditingChanged(sender:)), for: .editingDidEnd)

            if ((tf is XINumberTextFieldWithToolbar) == true) {
                tf.text = ""
            }
        }
    }
    
    // MARK: - protcol for UITextFieldDelegate
    /// フォーカス取得時（編集の開始時）
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        txtActiveField = textField
        return true
    }
    
    /// 閉じるボタン押下時
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// フォーカス喪失時
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        // for XINumberTextFieldWithToolbar
        let numTextField = textField as? XINumberTextFieldWithToolbar
        if (numTextField != nil ) {
            if numTextField?.isDecimalConvert == true { // 数値の時は、アプリが認識している数値を表示する（Swiftの仕様変更に備える対応）
                if numTextField?.text?.isEmpty != true{ // 小数点入力だけの場合は０として扱う
                    numTextField?.text = numTextField?.GetDecimalValue()?.description
                }
            }
            else {
                XIDialog.DispAlertMsg(pvc: self, msg: NSLocalizedString("MSG_ERR_NONUMBER", comment: "error"))
                return false
            }
        }
        
        return true
    }
  
    // MARK: - method internal
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
  
    /// TextFieldフォントサイズの最適化
    func adjustFontSizeOfTextFilds() {
        
        let allTextFields = getTextfields(view: self.view)
        for textField in allTextFields
        {
            textField.font = UIFont.boldSystemFont(ofSize: 46)
            var widthOfText: CGFloat = textField.text!.size(withAttributes: [NSAttributedString.Key.font: textField.font!]).width
            let widthOfFrame: CGFloat = textField.frame.size.width
            
            var heightOfText: CGFloat = textField.text!.size(withAttributes: [NSAttributedString.Key.font: textField.font!]).height
            let heightOfFrame: CGFloat = textField.frame.size.height
            
            while ((widthOfFrame - 15) < widthOfText) || ((heightOfFrame - 10) < heightOfText) {
                let fontSize: CGFloat = textField.font!.pointSize
                textField.font = textField.font?.withSize(CGFloat(fontSize - 0.5))
                widthOfText = (textField.text?.size(withAttributes: [NSAttributedString.Key.font: textField.font!]).width)!
                heightOfText = (textField.text?.size(withAttributes: [NSAttributedString.Key.font: textField.font!]).height)!
            }
        }
    }
    
    // MARK: - method private
    /// Notificationを設定
    private func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Notificationを削除
    private func removeObserver() {
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    // MARK: - callback for NotificationCenter
    /// キーボードが現れた時(TextFieldがキーボードに隠れない様にする対策)
    @objc func keyboardWillShow(notification: Notification?) {
        
        // TextFeildの下辺位置を取得
        let textFrame = txtActiveField.superview!.convert(txtActiveField.frame, to: nil)
        let txtLimit = textFrame.origin.y + textFrame.size.height
        
        // Keypadの上辺位置を取得
        let userInfo = notification?.userInfo!
        let keyboardScreenEndFrame = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        let kbdLimit = (myBoundSize.height - keyboardScreenEndFrame.size.height)

        
        print("txtLimit=", txtLimit)
        print("kbdLimit=", kbdLimit)
        
        // 表示が重なる場合はずらす
        if txtLimit >= kbdLimit {
            print("txtLimit - kbdLimit=", txtLimit - kbdLimit)
            self.view.frame.origin.y = kbdLimit - txtLimit
        }
    }
    /// キーボードが消えた時(TextFieldがキーボードに隠れない様にする対策)
    @objc func keyboardWillHide(notification: Notification?) {
        self.view.frame.origin.y = 0
    }
    
    // MARK: - callback for NSNotification of UITextField
    /// TextFieldのテキストが変更された時
    @objc func textFieldEditingChanged(sender: UITextField) {
        /* 各画面のViewControllerにてオーバーライドして計算処理を実装する */
    }
}
