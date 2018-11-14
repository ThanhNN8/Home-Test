//
//  ApiError.swift
//  
//
//  Created by NGUYEN NGOC THANH on 10/9/17.
//  Copyright © 2017 NGUYEN NGOC THANH. All rights reserved.
//

import Foundation
import Alamofire

class ApiError:NSError {
    var statusCode: Int
    var error: NSError
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(statusCode: Int, error: NSError) {
        self.statusCode = statusCode
        self.error      = error
        super.init(domain: error.domain, code: error.code, userInfo: error.userInfo)
    }
}
