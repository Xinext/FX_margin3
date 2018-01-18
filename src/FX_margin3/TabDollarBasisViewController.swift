//
//  TabDollarBasisViewController.swift
//  FX_margin3
//

import UIKit

class TabDollarBasisViewController: UIViewController  ,UITextFieldDelegate, UIScrollViewDelegate {
    
    var txtActiveField = UITextField()
    var scrollFormer:CGFloat! = nil
    let scrollViewsample = UIScrollView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        
        let mainViewFrame = UIScreen.main.bounds
        
        scrollViewsample.frame = mainViewFrame
        scrollViewsample.contentSize = CGSize(width:mainViewFrame.size.width , height:mainViewFrame.height + 150)
        let sampletextFile = UITextField()
        sampletextFile.delegate = self
        sampletextFile.text = "パターン2"
        sampletextFile.borderStyle = UITextBorderStyle.roundedRect
        sampletextFile.frame.size.width = mainViewFrame.size.width/2
        let rec = CGRect(x: mainViewFrame.midX - sampletextFile.frame.size.width/2, y: 500, width:mainViewFrame.size.width/2 , height:  40.0)
        sampletextFile.frame = rec
        self.view.addSubview(scrollViewsample)
        scrollViewsample.addSubview(sampletextFile)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    //UITextFieldが編集された直後に呼ばれる.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        //編集されたテキストフィールドを格納しておく
        txtActiveField = textField
        return true
    }
    
    @objc func handleKeyboardWillShowNotification(_ notification: Notification) {
        
        
        let userInfo = notification.userInfo!
        //キーボードの大きさ調べる
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        
        let scrollvalue = scrollViewsample.contentOffset.y
        scrollFormer = scrollViewsample.contentOffset.y
        
        //入力したテキストフィールドのy軸と高さと少し余白を足してテキストフィールドのマックスy値と少し余白のy軸をとる
        let txtLimit = txtActiveField.frame.maxY + 8.0
        let txtLimit1 = txtActiveField.frame.maxY + 8.0 - scrollvalue
        
        //現在のselfViewの高さから、キーボードの高さを引いて残りの幅の高さをみるy軸をみる
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        
        print("テキストフィールドの下辺：(\(txtLimit))")
        print("キーボードの上辺：(\(kbdLimit))")
        
        //キーボードよりテキストフィールドのy軸が大きかったらキーボードにかかっている状態。スクロールビューをその分移動させる。
        if txtLimit1 >= kbdLimit {
            scrollViewsample.contentOffset.y = txtLimit - kbdLimit
        }
    }
    
    @objc func handleKeyboardWillHideNotification(_ notification: Notification) {
        
        
        //スクロールしてある位置に戻す
        scrollViewsample.contentOffset.y = scrollFormer
    }
    
    
}






