//
//  BaseModelNewEvent.swift
//  LogLag
//
//  Created by NGUYEN NGOC THANH on 10/9/17.
//  Copyright © 2017 NGUYEN NGOC THANH. All rights reserved.
//

import Foundation
import UIKit

class BaseModelEvent: NSObject {
    
    var actionEvent: BaseActionEvent?
    var modelData: NSObject?
    var messageError: String?
    var errorCode: Int
    
    override init() {
        actionEvent = nil
        modelData = nil
        messageError = ""
        errorCode = -1
    }
}
