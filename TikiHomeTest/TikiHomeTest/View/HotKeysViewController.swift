//
//  HotKeysViewController.swift
//  TikiHomeTest
//
//  Created by NGUYEN NGOC THANH on 11/13/18.
//  Copyright © 2018 NGUYEN NGOC THANH. All rights reserved.
//

import UIKit
import RealmSwift

class HotKeysViewController: UIViewController {
    
    @IBOutlet weak var tophotkey_scroll: UIScrollView!
    @IBOutlet weak var history_scroll: UIScrollView!
    @IBOutlet weak var history_view: UIView!
    
    var hotkeys: [HotKey] = []
    var history_hotkeys: [HotKey] = []
    let margin: CGFloat = 16

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.sendRequestHotKeys()
        self.updateHistoryUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func updateUI() {
        var position_x: CGFloat = 8
        for i in 0..<hotkeys.count {
            let hotkey = hotkeys[i]
            let key = hotkey.keyword.calculateBestString()
            var width = key.bestWidth()
            if width < 100 {
               width = 100
            }
            width = width + 12
            let view = CustomHotKeyView.init(frame: CGRect(x: position_x, y: 0, width: width, height: 180))
            view.updateData(key: key, icon: hotkey.icon, index: i)
            view.delegate = self
            self.tophotkey_scroll.addSubview(view)
            position_x = position_x + width + margin
        }
        self.tophotkey_scroll.contentSize = CGSize(width: position_x, height: 180)
    }
    
    func sendRequestHotKeys() {
        let actionEvent = BaseActionEvent()
        actionEvent.action = .findHotKeys
        actionEvent.sender = self
        AppService.shared.handelReceiveRequestFromController(actionEvent: actionEvent)
    }
    
    // MARK: - History
    func updateHistoryUI() {
        // remove all data_first
        history_hotkeys.removeAll(keepingCapacity: false)
        for item in self.history_scroll.subviews {
            item.removeFromSuperview()
        }
        let realm = try! Realm()
        let results = realm.objects(HotKey.self).sorted(byKeyPath: "updated_time", ascending: false).toArray(ofType: HotKey.self)
        for item in results {
            history_hotkeys.append(item)
        }
        if history_hotkeys.count < 1 {
            // hidden history view
            history_view.isHidden = true
            return
        }
        history_view.isHidden = false
        // update new UI
        var position_x: CGFloat = 8
        for i in 0..<history_hotkeys.count {
            let hotkey = history_hotkeys[i]
            let key = hotkey.keyword.calculateBestString()
            var width = key.bestWidth()
            if width < 100 {
                width = 100
            }
            width = width + 12
            let view = CustomHistoryKeyWordView.init(frame: CGRect(x: position_x, y: 0, width: width, height: 80))
            
            view.updateData(key: key, index: i)
            self.history_scroll.addSubview(view)
            position_x = position_x + width + margin
        }
        self.history_scroll.contentSize = CGSize(width: position_x, height: 80)
    }
    
    // MARK: - IBAction
    @IBAction func clearAllHistory() {
        let alertController = UIAlertController.init(title: "THÔNG TIN", message: "Bạn có muốn xoá hết dữ liệu tìm kiếm?", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "BỎ QUA", style: .cancel, handler: { action in
            
        })
        let agreeAction = UIAlertAction.init(title: "ĐỒNG Ý", style: .default, handler: { action in
            self.confirmClearAllHistory()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(agreeAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func confirmClearAllHistory() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
            self.updateHistoryUI()
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HotKeysViewController: NetworkDelegate {
    func receiveDataFromModel(modelEvent: BaseModelEvent) {
        switch modelEvent.actionEvent!.action {
        case .findHotKeys:
            let data = modelEvent.modelData as! [HotKey]
            hotkeys.removeAll(keepingCapacity: false)
            for item in data {
                hotkeys.append(item)
            }
            self.updateUI()
            break
        default:
            break
        }
    }
    
    func receiveErrorFromModel(modelEvent: BaseModelEvent) {
        if let errorMes = modelEvent.messageError {
            let alertController = UIAlertController.init(title: "LỖI", message: errorMes, preferredStyle: .alert)
            let cancelAction = UIAlertAction.init(title: "ĐỒNG Ý", style: .cancel, handler: { action in
                
            })
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}

extension HotKeysViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, searchText.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            self.showHud("Đang tìm dữ liệu ...")
            self.perform(#selector(self.dismissMessageHud), with: nil, afterDelay: 3)
            self.storeKeyword(keyword: searchText)
        }
    }
    
    @objc func dismissMessageHud() -> Void {
        self.hideHUD()
    }
    
    func storeKeyword(keyword: String) {
        let realm = try! Realm()
        let obj = HotKey.init()
        obj.keyword = keyword
        obj.updated_time = Int(Date.init().timeIntervalSince1970)
        try! realm.write {
            realm.add(obj, update: true)
            self.updateHistoryUI()
        }
        
    }
}

extension HotKeysViewController: HotkeyViewDelegate {
    func clickOnItem(index: Int) {
        let hotkey = self.hotkeys[index]
        self.showHud("Đang tìm dữ liệu ...")
        self.perform(#selector(self.dismissMessageHud), with: nil, afterDelay: 3)
        self.storeKeyword(keyword: hotkey.keyword)
    }
    
    
}
