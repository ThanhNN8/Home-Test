//
//  ApiRequest.swift
//  
//
//  Created by NGUYEN NGOC THANH on 10/9/17.
//  Copyright © 2017 NGUYEN NGOC THANH. All rights reserved.
//

import Foundation
import Alamofire

class ApiRequest: URLRequestConvertible {
    let method:String
    let path:String
    let params:[String: AnyObject]?
    
    init(method: String, path: String) {
        self.method = method
        self.path   = path
        self.params = nil
    }
    
    init(method: String, path: String, params: [String: AnyObject]?) {
        self.method = method
        self.path   = path
        self.params = params
    }
    
    var headers: [String : String] {
        var headers:[String : String] = [:]
        headers["Time-Zone"] = NSTimeZone.local.identifier
        if let language = Bundle.main.preferredLocalizations.first as String? {
            headers["Accept-Language"] = language
        }
        if let apiToken = UserDefaults.standard.string(forKey: "token") {
            headers["Authorization"] = "Bearer " + apiToken
        }
        return headers
    }
    
    var url: String {
        return self.path
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL.init(string: self.url + self.path)!
        let request = NSMutableURLRequest.init(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields?.updateValue(NSTimeZone.local.identifier, forKey: "Time-Zone")
        if let apiToken = UserDefaults.standard.string(forKey: "token") {
            request.allHTTPHeaderFields?.updateValue("Bearer " + apiToken, forKey: "Authorization")
        }
        return request as URLRequest
    }
}
