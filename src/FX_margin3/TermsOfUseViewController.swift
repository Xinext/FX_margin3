// 
// FX_margin3
// TermsOfUseViewController.swift
//
//

import UIKit

class TermsOfUseViewController: UIViewController {

    // MARK: - private variable
    private var firstAppear: Bool = false
    
    // MARK: - IBOutlet
    @IBOutlet weak var outletMainCOntentsView: UIView!
    @IBOutlet weak var outletTOSTitleLabel: XIPaddingLabel!
    @IBOutlet weak var outletTOSTextLabel: XIPaddingLabel!
    @IBOutlet weak var outletTOSAgreementButton: XIPaddingButton!
    
    // MARK: - override for TermsOfUseViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        outletMainCOntentsView.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 最初に表示される時の処理
        if (firstAppear != true) {
            
            outletMainCOntentsView.isHidden = true  // メインコンテンツの準備ができるまで非表示
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 最初に表示される時の処理
        if (firstAppear != true) {
            
            outletTOSTitleLabel.FontSizeToFit()
            outletTOSAgreementButton.FontSizeToFit()
            
            outletMainCOntentsView.isHidden = false // メインコンテンツの準備が完了したので表示
            firstAppear = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
