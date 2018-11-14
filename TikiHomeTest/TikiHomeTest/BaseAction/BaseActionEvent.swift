//
//  BaseEvent.swift
//  LogLag
//
//  Created by NGUYEN NGOC THANH on 10/9/17.
//  Copyright © 2017 NGUYEN NGOC THANH. All rights reserved.
//

import Foundation
import UIKit

enum ActionEvent {
    case login
    case findHotKeys
}

protocol NetworkDelegate {
    
    func receiveDataFromModel (modelEvent: BaseModelEvent)
    func receiveErrorFromModel (modelEvent: BaseModelEvent)
}

class BaseActionEvent: NSObject {
    var action: ActionEvent
    var sender: NetworkDelegate?
    var viewData: NSObject?
    var tag: Int
    
    override init() {
        action = ActionEvent.login
        sender = nil
        viewData = nil
        tag = 0
    }
}
