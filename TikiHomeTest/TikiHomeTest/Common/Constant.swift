//
//  Constant.swift
//  
//
//  Created by NGUYEN NGOC THANH on 10/6/17.
//  Copyright © 2017 NGUYEN NGOC THANH. All rights reserved.
//

import Foundation
import UIKit

class Constant: NSObject {
    
    static var databaseVersion: UInt64 = 3
    
    // define color
    static var bg_item_color0: UIColor = 0x16702e.toUIColor
    static var bg_item_color1: UIColor = 0x005a51.toUIColor
    static var bg_item_color2: UIColor = 0x996c00.toUIColor
    static var bg_item_color3: UIColor = 0x5c0a6b.toUIColor
    static var bg_item_color4: UIColor = 0x006d90.toUIColor
    static var bg_item_color5: UIColor = 0x974e06.toUIColor
    static var bg_item_color6: UIColor = 0x99272e.toUIColor
    static var bg_item_color7: UIColor = 0x89221f.toUIColor
    static var bg_item_color8: UIColor = 0x00345d.toUIColor
    
    // font
    static var font_14 = UIFont.systemFont(ofSize: 14.0)
    
    static var screenWidth = UIScreen.main.bounds.size.width
    static var screenHeight = UIScreen.main.bounds.size.height
}
