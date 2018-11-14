//
//  ApiResponse.swift
//  
//
//  Created by NGUYEN NGOC THANH on 10/9/17.
//  Copyright © 2017 NGUYEN NGOC THANH. All rights reserved.
//

import Foundation
import Alamofire

class ApiResponse {
    var result: AnyObject?
    var headers: [String : String]
    
    init(result: AnyObject?, headers: [String : String]) {
        self.result = result
        self.headers = headers
    }
}
