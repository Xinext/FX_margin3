//
//  TradeTypePickerTextField.swift
//  FX_margin3
//

import UIKit

class TradeTypePickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - private variable
    private let pickerView = UIPickerView()
    let TypeTextAarray: [String] = ["買","売"]
    let TypeValueAarray: [Decimal] = [1,-1]
    
    // MARK: - initiallizer
    override init(frame: CGRect) {
        super.init(frame: frame)
        initConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initConfig()
    }
    
    // MARK: - configuration
    /// 各種設定の初期化
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
        
        let okButton   = UIBarButtonItem(title: "閉じる", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePressed))
        let spaceButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        
        toolBar.setItems([spaceButton, okButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        self.inputAccessoryView = toolBar
        
        pickerView.selectRow(0, inComponent: 0, animated: false)
        self.text = TypeTextAarray[0]
    }

    // MARK: - callback
    /// 閉じるボタン 押下
    @objc func donePressed() {
        self.superview?.endEditing(true)
    }
    
    // MARK: - protocol
    /// 表示する文字列
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TypeTextAarray[row]
    }
    
    /// 桁数の設定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// アイテムの表示個数の設定
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TypeTextAarray.count
    }
    
    /// 選択の処理
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text = TypeTextAarray[row]
    }

    // MARK: - method
    func GetDecimalValue() -> Decimal {
        return TypeValueAarray[pickerView.selectedRow(inComponent: 0)]
    }
}
