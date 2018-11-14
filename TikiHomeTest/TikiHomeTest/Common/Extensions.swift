//
//  Extensions.swift
//
//
//  Created by NGUYEN NGOC THANH on 10/6/17.
//  Copyright © 2017 NGUYEN NGOC THANH. All rights reserved.
//


import UIKit
import Foundation
import MBProgressHUD
import QuartzCore
import SDWebImage
import RealmSwift

extension UIImageView {
    func loadFromUrl(stringUrl: String) {
        self.sd_setImage(with: URL(string: stringUrl), placeholderImage: nil)
    }
    
    func loadFromUrl(stringUrl: String, placeHolder: UIImage) {
        self.sd_setImage(with: URL(string: stringUrl), placeholderImage: placeHolder)
    }
}

extension UIButton {
    func setBackgroundImageUrl(stringUrl: String) {
//        self.sd_setBackgroundImage(with: URL(string: stringUrl), for: .normal, completed: nil)
        self.sd_setBackgroundImage(with: URL(string: stringUrl), for: .normal, placeholderImage: #imageLiteral(resourceName: "icon_camera"), options: SDWebImageOptions.retryFailed, completed: nil)
    }
    func setBackgroundImageUrl(stringUrl: String, placehoder: UIImage) {
        self.sd_setBackgroundImage(with: URL(string: stringUrl), for: .normal, placeholderImage: placehoder, options: SDWebImageOptions.retryFailed, completed: nil)
    }
}

extension UIViewController {
    func showHud(_ message: String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = message
        hud.isUserInteractionEnabled = false
    }
    
    func hideHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
}

extension Int {
    var toUIColor: UIColor {
        let r = (CGFloat)(((self & 0xFF0000) >> 16)) / 255.0
        let g = (CGFloat)(((self & 0x00FF00) >> 08)) / 255.0
        let b = (CGFloat)(((self & 0x0000FF) >> 00)) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    public static func random(lower: Int = 0, _ upper: Int = 100) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }

}

protocol DataConvertible {
    init?(data: Data)
    var data: Data { get }
}

extension Dictionary {
    func toJSONString() -> String? {
        let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        return jsonString
    }
    
}

extension NSData {
    var contentTypeForImageData: String {
        
        var c: UInt8! = UInt8()
        self.getBytes(&c, length: 1)
        
        switch c {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x49, 0x4D:
            return "image/tif"
        default: return ""
        }
    }
}


extension UIView {
    func roundCorner(borderColor: UIColor, borderWidth: Float) {
        self.roundCorner(borderColor: borderColor, borderWidth: borderWidth, cornerRadius: self.frame.size.height / 2)
    }
    
    func roundCorner(borderColor: UIColor, borderWidth: Float, cornerRadius: CGFloat) {
        self.layer.cornerRadius  = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderWidth   = CGFloat(borderWidth)
        self.layer.borderColor   = borderColor.cgColor
    }
    
    func roundCornerForWrapperView(borderColor: UIColor) {
        self.roundCorner(borderColor: borderColor, borderWidth: 1.0, cornerRadius: 5.0)
    }

}

extension UIViewController {
    var appDelegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension NSRegularExpression {
    
    convenience init(pattern: String) {
        try! self.init(pattern: pattern, options: [])
    }
}

extension String {
    
    func calculateBestString() -> String {
        var string = self
        let string_size = string.count
        var mid = string_size/2
        if string_size%2 == 0 {
            mid = mid - 1
        }
        for i in 0...mid {
            let index = string.index(string.startIndex, offsetBy: (mid-i))
            if string[index] == " " {
                string.insert("\n", at: index)
                break
            }
            let after_index = string.index(string.startIndex, offsetBy: (mid+i))
            if (mid + i == string_size) {
                break
            }
            if string[after_index] == " " {
                string.insert("\n", at: after_index)
                break
            }
        }
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func bestWidth() -> CGFloat {
        let label = UILabel.init()
        label.text = self
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.sizeToFit()
        return label.frame.width
    }
    
}

extension Date {
    func toInt() -> Int {
        return Int(self.timeIntervalSince1970)
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}

