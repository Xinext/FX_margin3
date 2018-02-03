//
//  XIPaddingButton.swift
//


import UIKit

/**
 - UIButton with character size adjustment function
 - Author: xinext HF
 - Copyright: xinext
 - Date: 2017/04/12
 - Version: 1.0.0
 */
class XIPaddingButton: UIButton {

    // MARK: - private variable
    private var _paddingTop: CGFloat = 5
    private var _paddingBottom : CGFloat = 5
    private var _paddingLeft: CGFloat = 5
    private var _paddingRight: CGFloat = 5
    
    // MARK: - Interface Bilder property
    @IBInspectable var PaddingTop: CGFloat {
        get {
            return _paddingTop
        }
        set {
            _paddingTop = newValue
        }
    }
    
    @IBInspectable var PaddingBottom: CGFloat {
        get {
            return _paddingBottom
        }
        set {
            _paddingBottom = newValue
        }
    }
    
    @IBInspectable var PaddingRight: CGFloat {
        get {
            return _paddingRight
        }
        set {
            _paddingRight = newValue
        }
    }
    
    @IBInspectable var PaddingLeft: CGFloat {
        get {
            return _paddingLeft
        }
        set {
            _paddingLeft = newValue
        }
    }
    
    // MARK: - Public method
    /**
     Adjust font size according to padding setting.
     */
    public func FontSizeToFit() {
        
        self.fontSizeToFit(minimumFontScale: 0.2, diminishRate: 0.5)
    }
    
    /**
     (sub)Adjust font size according to padding setting.
     - minimumFontScale: CGFloat: minimum font scale
     - diminishRate: CGFloat: diminish rate of font size
     */
    private func fontSizeToFit(minimumFontScale: CGFloat, diminishRate: CGFloat) {
        
        let padding = UIEdgeInsets(top: _paddingTop, left: _paddingLeft, bottom: _paddingBottom, right: _paddingRight)
        
        let text = self.titleLabel!.text
        if (text!.count == 0) {
            return
        }
        var size = self.frame.size
        size.height = (size.height) - (padding.bottom + padding.top)
        size.width = (size.width) - (padding.left + padding.right)
        
        let fontName = self.titleLabel!.font.fontName
        let fontSize = self.titleLabel!.font.pointSize
        let minimumFontSize = fontSize * minimumFontScale
        let isOneLine = (self.titleLabel!.numberOfLines == 1)
        
        var boundingSize = CGSize.zero
        var area = CGSize.zero
        var font = UIFont()
        var fs = fontSize
        var newAttributes = [NSAttributedStringKey : Any]()
        self.titleLabel!.attributedText?.enumerateAttributes(in: NSMakeRange(0, text!.count), options: .longestEffectiveRangeNotRequired, using: {
            (attributes: [NSAttributedStringKey : Any], range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            newAttributes = attributes
        })
        if newAttributes.count == 0 {
            return
        }
        while (true) {
            font = UIFont(name: fontName, size: fs)!
            newAttributes[NSAttributedStringKey.font] = font
            
            if isOneLine {
                boundingSize = CGSize(width: CGFloat(MAXFLOAT), height: size.height)
            }
            else {
                boundingSize = CGSize(width: size.width, height: CGFloat(MAXFLOAT))
            }
            area = NSString(string: text!).boundingRect(with: boundingSize, options: .usesLineFragmentOrigin, attributes: newAttributes, context: nil).size
            
            if isOneLine {
                if (area.width <= size.width && area.height <= size.height ) {
                    break;
                }
            }
            else {
                if area.height <= size.height {
                    break;
                }
            }
            
            if fs == minimumFontSize {
                break;
            }
            
            fs -= diminishRate
            if fs < minimumFontSize {
                fs = minimumFontSize
            }
        }
        
        self.titleLabel!.font = font
    }

}

