//
//  XIPaddingLabel.swift
//


import UIKit

/**
 - UIButton with character size adjustment function
 - Author: xinext HF
 - Copyright: xinext
 - Date: 2017/04/12
 - Version: 1.0.0
 */
class XIPaddingLabel: UILabel {

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
    
    // MARK: - UILabel Override
    private var _padding: UIEdgeInsets {
        return UIEdgeInsets(top: PaddingTop, left: PaddingLeft, bottom: PaddingBottom, right: PaddingRight)
    }

    override func drawText(in rect: CGRect) {
        let newRect = rect.inset(by: _padding)
        super.drawText(in: newRect)
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += _padding.top + _padding.bottom
        contentSize.width += _padding.left + _padding.right
        return contentSize
    }
    
    // MARK: - Public method
    /**
     Adjust font size according to padding setting.
     */
    public func FontSizeToFit() {
        
        self.lineBreakMode = .byClipping
        self._fontSizeToFit(minimumFontScale: 0.1, diminishRate: 0.5)
    }
    
    /**
     (sub)Adjust font size according to padding setting.
     - minimumFontScale: CGFloat: minimum font scale
     - diminishRate: CGFloat: diminish rate of font size
     */
    private func _fontSizeToFit(minimumFontScale: CGFloat, diminishRate: CGFloat) {
        
        let padding = UIEdgeInsets(top: _paddingTop, left: _paddingLeft, bottom: _paddingBottom, right: _paddingRight)
        
        let text = self.text
        if ( text == nil ){return}
        
        if (text!.count == 0) {
            return
        }
        var size = self.frame.size
        size.height = (size.height) - (padding.bottom + padding.top)
        size.width = (size.width) - (padding.left + padding.right)
        
        let fontName = self.font.fontName
        let fontSize = self.font.pointSize
        let minimumFontSize = fontSize * minimumFontScale
        let isOneLine = (self.numberOfLines == 1)
        
        var boundingSize = CGSize.zero
        var area = CGSize.zero
        var font = UIFont()
        var fs = fontSize
        var newAttributes = [NSAttributedString.Key : Any]()
        self.attributedText?.enumerateAttributes(in: NSMakeRange(0, text!.count), options: .longestEffectiveRangeNotRequired, using: {
            (attributes: [NSAttributedString.Key : Any], range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            newAttributes = attributes
        })
        if newAttributes.count == 0 {
            return
        }
        while (true) {
            font = UIFont(name: fontName, size: fs)!
            newAttributes[NSAttributedString.Key.font] = font
            
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
                if (area.width <= size.width) && (area.height <= size.height) {
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
        
        self.font = font
    }

}
