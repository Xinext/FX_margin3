//
//  CXIommonUtility.swift
//

import Foundation
import UIKit

/**
 - [ENG]MessageBox Utilty
 - [JPN]メセージボックスユーティリティー
 */
class XIDialog {
    
    /**
     Displays a alert message dialog.
     - parameter pvc: ViewController Parent ViewController.
     - parameter msg: Display message.
     */
    static func DispAlertMsg( pvc:UIViewController, msg: String ){
        
        let titleText = NSLocalizedString("STR_ALERT", comment: "ALERT")
        let alertController: UIAlertController = UIAlertController(title: titleText, message: msg, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default){
            (action) -> Void in
        }
        alertController.addAction(actionOK)
        pvc.present(alertController, animated: true, completion: nil)
    }
    
    /**
     Displays a Confirmation dialog.
     - parameter pvc: ViewController Parent ViewController.
     - parameter msg: Display message.
     */
    static func DispConfirmationMsg( pvc:UIViewController, msg: String, handler proc: (() -> Swift.Void)? = nil ) {
        
        let titleText = NSLocalizedString("STR_CONFIRMATION", comment: "Confirmation")
        let alertController: UIAlertController = UIAlertController(title: titleText, message: msg, preferredStyle: .alert)
        
        let actionYes = UIAlertAction(title: NSLocalizedString("STR_YES", comment: "Yes"),
                                      style: .destructive,
                                      handler:{(action:UIAlertAction!) in proc!()})
        alertController.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: NSLocalizedString("STR_NO", comment: "No"), style: .cancel)
        alertController.addAction(actionNo)
        
        pvc.present(alertController, animated: true, completion: nil)
    }
    
    /**
     Displays a selection dialog for navigating to the application setting page.
     - parameter pvc: ViewController Parent ViewController.
     - parameter msg: Display message.
     */
    static func DispSelectSettingPage( pvc:UIViewController, msg: String, cancelHandler: (() -> Swift.Void)? = nil ){
        
        let titleText = NSLocalizedString("STR_ALERT", comment: "ALERT")
        let alertController: UIAlertController = UIAlertController(title: titleText, message: msg, preferredStyle: .alert)
        
        // Create action and added.
        // Cancel
        let cancelAction:UIAlertAction = UIAlertAction(title: NSLocalizedString("STR_CANCEL", comment: "Cancel"),
                                                       style: UIAlertAction.Style.cancel,
                                                       handler:{(action:UIAlertAction!) in cancelHandler!()
                                                        })
        
        // To Setting page
        let defaultAction:UIAlertAction = UIAlertAction(title: NSLocalizedString("STR_TO_SETTING_PAGE", comment: "To settings"),
                                                        style: UIAlertAction.Style.default,
                                                        handler:{
                                                            (action:UIAlertAction!) -> Void in
                                                            let url = NSURL(string:UIApplication.openSettingsURLString)
                                                            if #available(iOS 10.0, *) {
                                                                UIApplication.shared.open(url! as URL,options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil )
                                                            } else {
                                                                UIApplication.shared.openURL(url! as URL)
                                                            }
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        
        pvc.present(alertController, animated: true, completion: nil)
    }
 }

/**
 - UIColorへ１６進数にてRGB指定できる機能を拡張
 */
extension UIColor {
    class func hexStr ( hexStr : NSString, alpha : CGFloat) -> UIColor {
        let alpha = alpha
        var hexStr = hexStr
        hexStr = hexStr.replacingOccurrences(of: "#", with: "") as NSString
        let scanner = Scanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string")
            return UIColor.white;
        }
    }
}

/**
 - UIImageへ画像サイズ調整機能を拡張
 */
extension UIImage{
    func ResizeUIImage(width : CGFloat, height : CGFloat)-> UIImage!{
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

/**
 - 最前面のUIViewController取得機能を拡張
 */
extension UIApplication {
    
    class func GetTopViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return GetTopViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return GetTopViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return GetTopViewController(controller: presented)
        }
        return controller
    }
}

/**
 - UIViewの枠設定機能を拡張
 */
extension UIView {
    
    // 枠線の色
    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor.map { UIColor(cgColor: $0) }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    // 枠線のWidth
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    // 角丸設定
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

/**
 - 親ViewControllerの取得
 */
extension UIView {
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            parentResponder = nextResponder
        }
    }
}

/**
 - UITabBarの色設定機能を拡張
 */
extension UITabBar {
    
    /// バーの色
    @IBInspectable var BarColor: UIColor {
        get {
            return self.barTintColor!
        }
        set {
            self.barTintColor = newValue
        }
    }
    
    /// 選択されているテキスト色
    @IBInspectable var SelectedTextColor: UIColor {
        get {
            return self.tintColor!
        }
        set {
            self.tintColor = newValue
        }
    }

}

/**
 - 文字列検索拡張
 */
extension String {
    
    //絵文字など(2文字分)も含めた文字数を返します
    var length: Int {
        let string_NS = self as NSString
        return string_NS.length
    }
    
    //正規表現の検索をします
    func pregMatche(pattern: String, options: NSRegularExpression.Options = []) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return false
        }
        let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, self.length))
        return matches.count > 0
    }
    
    //正規表現の検索結果を利用できます
    func pregMatche(pattern: String, options: NSRegularExpression.Options = [], matches: inout [String]) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return false
        }
        let targetStringRange = NSRange(location: 0, length: self.length)
        let results = regex.matches(in: self, options: [], range: targetStringRange)
        for i in 0 ..< results.count {
            for j in 0 ..< results[i].numberOfRanges {
                let range = results[i].range(at: j)
                matches.append((self as NSString).substring(with: range))
            }
        }
        return results.count > 0
    }
    
    //正規表現の置換をします
    func pregReplace(pattern: String, with: String, options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.length), withTemplate: with)
    }
}

extension Decimal {
    
    /// Round `Decimal` number to certain number of decimal places.
    ///
    /// - Parameters:
    ///   - scale: How many decimal places.
    ///   - roundingMode: How should number be rounded. Defaults to `.plain`.
    /// - Returns: The new rounded number.
    
    func rounded(_ scale: Int, roundingMode: RoundingMode = .plain) -> Decimal {
        var value = self
        var result: Decimal = 0
        NSDecimalRound(&result, &value, scale, roundingMode)
        return result
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
