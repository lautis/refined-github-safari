//
//  SafariExtensionHandler.swift
//  Refined Github Extension
//
//  Created by Ville Lautanala on 17/02/2019.
//  Copyright © 2019 Ville Lautanala. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    var data = [String: [String: Any]]()
    
    func getValues<K,V>(data: [K: V], keys: [K]?) -> [K: V] {
        if let stringKeys = keys {
            return stringKeys.reduce(into: [K: V]()) { values, key in
                values[key] = data[key]
            }
        } else {
            return data
        }
    }

    func respondGet(userInfo: [String : Any]?, from page: SFSafariPage) {
        guard let payload = userInfo else { return }
        guard let namespace = payload["namespace"] as? String else { return }
        let keys = payload["keys"] as? [String]
        
        let data = self.readLocalStorage(namespace: namespace)
        let value = self.getValues(data: data, keys: keys)
        NSLog("Respond get with (\(value))")
        
        if let id = payload["id"] as? String {
            page.dispatchMessageToScript(withName: "get-response", userInfo: [
                "id": id,
                "value": data
                ])
        }
    }
    
    func injectSettings(namespace: String, data: [String: Any]) -> [String: Any] {
        guard namespace == "sync" else { return data }
        
        let options = [
            "disabledFeatures": "show-recently-pushed-branches-on-more-pages split-issue-pr-search-results"
        ]
        
        return data.merging(["options": options], uniquingKeysWith: { (_, last) in last })
    }
    
    func readLocalStorage(namespace: String) -> [String: Any] {
        let data = self.data[namespace, default: [String: Any]()]
        return self.injectSettings(namespace: namespace, data: data)
    }
    
    func respondSet(userInfo: [String : Any]?, from page: SFSafariPage) {
        guard let namespace = userInfo?["namespace"] as? String else { return }

        let oldValue = self.readLocalStorage(namespace: namespace)
        if let values = userInfo?["values"] as? Dictionary<String, Any> {
            self.data[namespace] = oldValue.merging(values) { (_, last) in last }
            
            // TODO: all pages / windows
            page.dispatchMessageToScript(withName: "storage-change", userInfo: ["old": self.getValues(data: oldValue, keys: Array(values.keys)), "new": values, namespace: namespace])
        }
        
        if let id = userInfo?["id"] as? String {
            page.dispatchMessageToScript(withName: "set-response", userInfo: [
                "id": id
                ])
        }
        

    }
    func respondMessage(userInfo: [String : Any]?, from page: SFSafariPage) {
        guard userInfo != nil && (userInfo?["action"] as? String) == "openAllInTabs" else { return }
        guard let pages = userInfo?["urls"] as? [String] else { return }
        let urls = pages.compactMap { URL(string: $0) }

        SFSafariApplication.getActiveWindow { (activeWindow) in
            urls.forEach({ (url) in activeWindow?.openTab(with: url, makeActiveIfPossible: false) })
        }
    }
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        NSLog("Received message \"\(messageName)\" with userInfo (\(userInfo ?? [:]))")

        switch (messageName) {
        case "get":
            self.respondGet(userInfo: userInfo, from: page)
        case "set":
            self.respondSet(userInfo: userInfo, from: page)
        case "message":
            self.respondMessage(userInfo: userInfo, from: page)
        default:
            NSLog("Received unkown message with userInfo (\(userInfo ?? [:]))")
        }
    }
}
