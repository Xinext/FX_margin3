//
//  TopViewController.swift
//  FX_margin3
//

import UIKit

class TopViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var outletADViewHightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var outletMainContentsView: UIView!
    @IBOutlet weak var outletADBannerView: UIView!
    
    // MARK: - Private variable
    private var adMgr = AdModMgr()
    private var firstAppear: Bool = false
    
    // MARK: - ViewController Override
    /**
     画面の自動回転をさせない
     */
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    
    /**
     画面をPortraitに固定する
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    /**
     [EventHandler]Viewの生成時
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let statusBar = UIView(frame:CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
        statusBar.backgroundColor = UIColor.black
        
        view.addSubview(statusBar)
    }

    /**
     [EventHandler]Viewが表示される直前時
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 最初に表示される時の処理
        if (firstAppear != true) {
            outletMainContentsView.isHidden = true  // メインコンテンツの準備ができるまで非表示
        }
    }
    
    /**
     [EventHandler]Viewが表示された直後時
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 最初に表示される時の処理
        if (firstAppear != true) {
            
            // 広告マネージャーの初期化
            adMgr.InitManager(pvc: self, adView: outletADBannerView, hightLC: outletADViewHightLayoutConstraint)
            adMgr.AdjustPosition(viewWidth: outletADBannerView.frame.size.width)
            
            // メインコンテンツの準備が完了したので表示
            outletMainContentsView.isHidden = false
            firstAppear = true
        }

    }
    
    /**
     [EventHandler]メモリエラー発生時
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
