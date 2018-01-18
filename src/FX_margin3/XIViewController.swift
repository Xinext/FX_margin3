//
//  XIViewController.swift
//  FX_margin3
//

import UIKit

class XIViewController: UIViewController, UITextFieldDelegate  {

    // MARK: - private variable
    private var txtActiveField = UITextField()

    // MARK: - Override for UIViewControllerevent handlers
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    

    // MARK: - Callback function for delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        txtActiveField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Open method
    /// Notificationを設定
    func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /// Notificationを削除
    func removeObserver() {
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    // MARK: - #selector method
    /// キーボードが現れた時
    @objc func keyboardWillShow(notification: Notification?) {
        
        // TextFeildの下辺位置を取得
        let textFrame = txtActiveField.superview!.convert(txtActiveField.frame, to: nil)
        let txtLimit = textFrame.origin.y + textFrame.size.height
        
        // Keypadの上辺位置を取得
        let userInfo = notification?.userInfo!
        let keyboardScreenEndFrame = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        let kbdLimit = (myBoundSize.height - keyboardScreenEndFrame.size.height)

        // 表示が重なる場合はずらす
        if txtLimit >= kbdLimit {
            print("txtLimit - kbdLimit=", txtLimit - kbdLimit)
            self.view.frame.origin.y = kbdLimit - txtLimit
        }
    }
    
    /// キーボードが消えたときに、画面を戻す
    @objc func keyboardWillHide(notification: Notification?) {
        self.view.frame.origin.y = 0
        
    }
    

    
}
