//
//  HotKey.swift
//
//
//  Created by NGUYEN NGOC THANH on 6/27/18.
//  Copyright © 2018 NGUYEN NGOC THANH. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm
import BoltsSwift

class HotKey: Object, Mappable {
    @objc dynamic var icon = ""
    @objc dynamic var keyword = ""
    @objc dynamic var updated_time = -1
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override class func primaryKey() -> String? {
        return "keyword"
    }
    
    class func parseArrayInBackground(response: Dictionary<String, AnyObject>) -> Task<AnyObject> {
        let taskSource = TaskCompletionSource<AnyObject>()
        if let result = response["keywords"] as? [Dictionary<String, AnyObject>] {
            var objs: [HotKey] = []
            for objectJson in result {
                let obj = HotKey(JSON: objectJson)
                objs.append(obj!)
            }
            taskSource.set(result: objs as AnyObject)
        } else {
            taskSource.set(error: NSError(domain: "", code: 0, userInfo: nil))
        }
        return taskSource.task
    }
    
    
    func mapping(map: Map) {
        icon            <- map["icon"]
        keyword         <- map["keyword"]
        updated_time         <- map["updated_time"]
    }
}
