//
//  TabYenBasisViewController.swift
//  FX_margin3
//

import UIKit

class TabYenBasisViewController: XIViewController {

    
    private let TRADETYPE_SHORT: Int = 0
    private let TRADETYPE_LONG: Int = 1

    @IBOutlet weak var outletMainContentsView: UIView!
    private var firstAppear: Bool = false
    
    @IBOutlet weak var outletTradeTypeSegment: UISegmentedControl!
    
    @IBOutlet weak var outletYenRateValueTextField: YenRateValueTextField!
    
    @IBOutlet weak var outletTradeTypeTextField: TradeTypePickerTextField!

    @IBOutlet weak var outletLotsTitleLabel: XIPaddingLabel!
    @IBOutlet weak var outletMarginTitleLabel: XIPaddingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        outletYenRateValueTextField.delegate = self
        outletTradeTypeTextField.delegate = self
        
        //setTapGestureRecognizerForLabel(outletLeverageValueLabel)
        
        setTradeTypeSegment(TRADETYPE_LONG)
  
    }

   
    
    
    /**
     Viewが表示される直前に呼び出されるイベントハンドラー
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 最初に表示される時の処理
        if (firstAppear != true) {
            outletMainContentsView.isHidden = true  // メインコンテンツの準備ができるまで非表示
        }

    }
    
    /**
     Viewが表示された直後に呼び出されるイベントハンドラー
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 最初に表示される時の処理
        if (firstAppear != true) {
            
            outletMarginTitleLabel.FontSizeToFit()
            outletLotsTitleLabel.FontSizeToFit()
            //adjustFontSizeOfLabels()
            
            //outletLotsTitleLabel.FontSizeToFit()
            //outletLotsTitle2Label.FontSizeToFit()
            
            //print("outletLotsTitleLabel.font.pointSize=", outletLotsTitleLabel.font.pointSize)
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
    

    func setTapGestureRecognizerForLabel(_ label: UILabel) {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
    }
    
    //UILabelをタップした時に動く関数
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        /*
        if ( sender.view == outletRateValueLabel ) {
            print("outletRateValueLabel tap working")
            
            //let xibView = NumericKeypadView(frame: self.view.frame )
            //self.view.addSubview(xibView)
            
            let nextvc = NumericKeypadViewController()
            //nextvc.view.backgroundColor = UIColor.blue
            self.present(nextvc, animated: true, completion: nil)
        }
        */
        /*
        if ( sender.view == outletLeverageValueLabel ) {
            print("outletLeverageValueLabel tap working")
        }
 */
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    /**
     セグメントコントロールの設定 for 取引種別
     */
    private func setTradeTypeSegment(_ type: Int) {
        /*
        // 選択セグメントの背景色をチーム色へ設定する
        switch type {
        case TRADETYPE_SHORT:
            outletTradeTypeSegment.tintColor = UIColor(red: 0, green: 0, blue: 255, alpha: 1)
            
        case TRADETYPE_LONG:
            outletTradeTypeSegment.tintColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
        default:
            break
        }
        
        // 共通文字色設定
        let attributeNormal = [NSAttributedStringKey.foregroundColor:UIColor.white]
        outletTradeTypeSegment.setTitleTextAttributes(attributeNormal, for: .normal)
        let attributeSelected = [NSAttributedStringKey.foregroundColor:UIColor.black]
        outletTradeTypeSegment.setTitleTextAttributes(attributeSelected, for: .selected)
        
        outletTradeTypeSegment.backgroundColor = UIColor.gray
 */
    }
    
    @IBAction func actionTradeTypeValueChanged(_ sender: Any) {
        setTradeTypeSegment(outletTradeTypeSegment.selectedSegmentIndex)
    }
    
    
    func getTextfield(view: UIView) -> [UITextField] {
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                results += [textField]
            } else {
                results += getTextfield(view: subview)
            }
        }
        return results
    }
    
    func adjustFontSizeOfTextFilds() {
        
        let allTextFields = getTextfield(view: self.view)
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
    
    func getLabelArray(view: UIView) -> [UILabel] {
        var results = [UILabel]()
        for subview in view.subviews as [UIView] {
            if let label = subview as? UILabel {
                results += [label]
            } else {
                results += getLabelArray(view: subview)
            }
        }
        return results
    }
    
    func adjustFontSizeOfLabels() {
    
        let labelArray = getLabelArray(view: self.view)
        var minPointSize = labelArray[0].font.pointSize
        for label in labelArray
        {
            if minPointSize > label.font.pointSize {
               minPointSize = label.font.pointSize
            }
        }
        
        for label in labelArray
        {
            label.font = label.font?.withSize(minPointSize)
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        adjustFontSizeOfTextFilds()

    }
 
}
