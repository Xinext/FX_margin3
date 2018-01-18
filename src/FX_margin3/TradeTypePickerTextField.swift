//
//  TradeTypePickerTextField.swift
//  FX_margin3
//

import UIKit

class TradeTypePickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Private variable
    let pickerView = UIPickerView()
    let typeAarray = ["売", "買"]
    
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
        
        // PickerViewの設定
        pickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: pickerView.bounds.size.height)
        pickerView.delegate   = self
        pickerView.dataSource = self
        
        // PickerView表示用Viewの設定
        let vi = UIView(frame: pickerView.bounds)
        vi.backgroundColor = UIColor.white
        vi.addSubview(pickerView)
        self.inputView = vi
        
        // ツールバーの設定
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        
        let okButton   = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.donePressed))
        let spaceButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        
        toolBar.setItems([spaceButton, okButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        self.inputAccessoryView = toolBar
        
        self.text = typeAarray[0]
    }

    // Done
    @objc func donePressed() {
        
        self.superview?.endEditing(true)
    }
    /// 表示する文字列
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeAarray[row]
    }
    
    /// 桁数の設定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// アイテムの表示個数の設定
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeAarray.count
    }
    
    /// 選択の処理
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text = typeAarray[row]
    }

}
