//
//  ApiClient.swift
//
//
//  Created by NGUYEN NGOC THANH on 10/9/17.
//  Copyright © 2017 NGUYEN NGOC THANH. All rights reserved.
//

import Foundation
import Alamofire
import BoltsSwift

class ApiClient {
    
//    class func callInBackground(request: String) -> Task<AnyObject> {
//        let task = TaskCompletionSource<AnyObject>()
//        print("https://glosbe.com/gapi/translate?from=eng&dest=vi&format=json&phrase=\(request)&pretty=true&tm=true")
//        Alamofire.request("https://glosbe.com/gapi/translate?from=eng&dest=vi&format=json&phrase=\(request)&pretty=true&tm=true").responseJSON { response in
//            if let JSON = response.result.value {
//                task.set(result: JSON as AnyObject)
//            } else {
//                task.set(result: "" as AnyObject)
//            }
//        }
//        return task.task
//    }
    
    class func callInBackground(request: ApiRequest) -> Task<AnyObject> {
        let taskSource = TaskCompletionSource<AnyObject>()
        var method: HTTPMethod?
        if request.method == "POST" {
            method = HTTPMethod.post
        } else if request.method == "GET" {
            method = HTTPMethod.get
        } else {
            method = HTTPMethod.post
        }
        Alamofire.request(request.url, method: method!, parameters: request.params, encoding: JSONEncoding.default, headers: request.headers).responseJSON { response in
            if let statusCode = response.response?.statusCode, statusCode == 200 {
                if let value = response.result.value {
                    print("response json:\(value)")
                    if let _ = value as? Dictionary<String, AnyObject> {
                        taskSource.set(result: ApiResponse(result: value as AnyObject, headers: response.response!.allHeaderFields as! [String : String]))
                    } else {
                        taskSource.set(error: (ApiError(statusCode: (response.response?.statusCode)!, error: NSError(domain: "", code: 0, userInfo: nil))))
                    }
                } else {
                    taskSource.set(error: (ApiError(statusCode: (response.response?.statusCode)!, error: NSError(domain: "", code: 0, userInfo: nil))))
                }
            } else {
                if let statusCode = response.response?.statusCode {
                    taskSource.set(error: (ApiError(statusCode: statusCode, error: NSError(domain: "", code: statusCode, userInfo: response.result.value as? Dictionary<String, AnyObject>))))
                } else {
                    taskSource.set(error: (ApiError(statusCode: 500, error: NSError(domain: "", code: 0, userInfo: nil))))
                }
            }
            
        }
        return taskSource.task
    }
}
