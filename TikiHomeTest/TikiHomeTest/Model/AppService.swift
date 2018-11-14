//
//  AppService.swift
//  TikiHomeTest
//
//  Created by NGUYEN NGOC THANH on 11/13/18.
//  Copyright © 2018 NGUYEN NGOC THANH. All rights reserved.
//

import Foundation
import BoltsSwift

class AppService: NSObject {
    static let shared = AppService()
    
    
    func handelReceiveRequestFromController (actionEvent: BaseActionEvent) {
        switch actionEvent.action {
        case .findHotKeys:
            self.findHotKeys(actionEvent: actionEvent)
        default:
            break
        }
    }
    
    func findHotKeys(actionEvent: BaseActionEvent) {
        let request = ApiRequest (
            method: "GET",
            path: "https://tiki-mobile.s3-ap-southeast-1.amazonaws.com/ios/keywords.json",
            params: nil
        )
        ApiClient.callInBackground(request: request).continueOnSuccessWithTask {taskResponse -> Task<AnyObject> in
            let apiResponse = taskResponse as! ApiResponse
            return HotKey.parseArrayInBackground(response: apiResponse.result as! Dictionary<String, AnyObject>)
            }.continueWith(Executor.mainThread) { task in
            if task.cancelled {
                // Save was cancelled
            } else if task.faulted {
                // Save failed
                self.checkError(task: task, actionEvent: actionEvent)
            } else {
                // Object was successfully saved
                let hotkeys = task.result as! [HotKey]
                self.receiveDataFromRequest(data: hotkeys as NSObject, actionEvent: actionEvent)
            }
        }
    }
    
    func checkError(task: Task<AnyObject>, actionEvent: BaseActionEvent) {
        if let _ = task.error as? ApiError {
            self.receiveErrorFromRequest(errorMessage: "Máy chủ đang bận, vui lòng thử lại sau!", actionEvent: actionEvent)
        } else {
            self.receiveErrorFromRequest(errorMessage: "Máy chủ đang bận, vui lòng thử lại sau!", actionEvent: actionEvent)
        }
    }
    
    func receiveDataFromRequest(data: NSObject?, actionEvent: BaseActionEvent) {
        let modelEvent: BaseModelEvent = BaseModelEvent()
        modelEvent.actionEvent = actionEvent
        modelEvent.modelData = data
        if let delegate = actionEvent.sender {
            delegate.receiveDataFromModel(modelEvent: modelEvent)
        }
    }
    
    func receiveErrorFromRequest(errorMessage: String?, actionEvent: BaseActionEvent, errorCode: Int = 0) {
        let modelEvent: BaseModelEvent = BaseModelEvent()
        modelEvent.actionEvent = actionEvent
        modelEvent.errorCode = errorCode
        modelEvent.messageError = errorMessage
        if let delegate = actionEvent.sender {
            delegate.receiveErrorFromModel(modelEvent: modelEvent)
        }
    }
}
