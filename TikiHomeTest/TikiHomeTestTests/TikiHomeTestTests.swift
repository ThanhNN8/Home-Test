//
//  TikiHomeTestTests.swift
//  TikiHomeTestTests
//
//  Created by NGUYEN NGOC THANH on 11/13/18.
//  Copyright © 2018 NGUYEN NGOC THANH. All rights reserved.
//

import XCTest
import RealmSwift
@testable import TikiHomeTest

class TikiHomeTestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testCreateHotkey() {
        let hotkey = HotKey()
        hotkey.keyword = "Key word"
        hotkey.icon = "https://tiki.vn"
        hotkey.updated_time = Int(Date.init().timeIntervalSince1970)
        XCTAssertNotNil(hotkey)
    }
    
    func testSaveHotkeyToRealm() {
        let realm = try! Realm()
        let hotkey = HotKey()
        hotkey.keyword = "Keyword"
        hotkey.icon = "https://tiki.vn"
        hotkey.updated_time = Int(Date.init().timeIntervalSince1970)
        try! realm.write {
            realm.add(hotkey, update: true)
            XCTAssertTrue(hotkey.updated_time >= 1)
        }
    }
    
    func testUpdateHotkeyFromRealm() {
        let realm = try! Realm()
        if let hotkey = realm.objects(HotKey.self).first {
            try! realm.write {
                hotkey.updated_time = Int(Date.init().timeIntervalSince1970)
                XCTAssertTrue(hotkey.updated_time >= 1)
            }
        } else {
            XCTFail("Please save object first!")
        }
        
    }
    
    func testDeleteAllHistory() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        let hotkey = realm.objects(HotKey.self).first
        XCTAssertNil(hotkey)
    }
    
    func testParseHotkeyObject() {
        let json = "{\"keywords\": [{\"keyword\": \"iphone\", \"icon\": \"https://tee.tikicdn.com/cache/w300/ts/product/65/af/4a/cf7f612a16299f2dc4c53d0c57569d2a.jpg\"}]}"
        if let data = json.data(using: .utf8) {
            do {
                let jsonObjct = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                HotKey.parseArrayInBackground(response: jsonObjct! as Dictionary<String, AnyObject>).continueWith() { task in
                    if task.cancelled {
                        // Save was cancelled
                    } else if task.faulted {
                        // Save failed
                        XCTFail("Parse data error")
                    } else {
                        // Object was successfully saved
                        let hotkeys = task.result as! [HotKey]
                        XCTAssertTrue(hotkeys.count == 1)
                    }
                }
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
