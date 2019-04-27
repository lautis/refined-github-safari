//
//  SafariExtensionHandler.swift
//  Refined GitHub for Safari Extension
//
//  Created by Ville Lautanala on 17/02/2019.
//  Copyright © 2019 Ville Lautanala. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    var syncData: [String: Any] = [
        "options": [
            "disabledFeatures": "recently-pushed-branches-enhancements split-issue-pr-search-results tags-dropdown"
        ]
    ];
    var localData = [String: Any]();
    
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
        
        if let id = payload["id"] as? String {
            page.dispatchMessageToScript(withName: "get-response", userInfo: [
                "id": id,
                "value": value
                ])
        }
    }
    
    func readLocalStorage(namespace: String) -> [String: Any] {
        if (namespace == "sync") {
            return self.syncData;
        } else {
            return self.localData;
        }
    }
    
    func respondSet(userInfo: [String : Any]?, from page: SFSafariPage) {
        guard let message = userInfo else { return }
        guard let namespace = message["namespace"] as? String else { return }
        guard let values = message["values"] as? Dictionary<String, Any> else { return }

        let oldValue = self.readLocalStorage(namespace: namespace)
        let newValue = oldValue.merging(values) { (_, last) in last }
        
        if (namespace == "sync") {
            self.syncData = newValue
        } else {
            self.localData = newValue
        }
        
        // TODO: all pages / windows
        page.dispatchMessageToScript(withName: "storage-change", userInfo: ["old": self.getValues(data: oldValue, keys: Array(values.keys)), "new": values, namespace: namespace])
        
        if let id = message["id"] as? String {
            page.dispatchMessageToScript(withName: "set-response", userInfo: [
                "id": id
                ])
        }
    }
    func respondMessage(userInfo: [String : Any]?, from page: SFSafariPage) {
        guard let payload = userInfo else { return }
        guard (payload["action"] as? String) == "openAllInTabs" else { return }
        guard let payloadUrls = payload["urls"] as? [String] else { return }

        let urls = payloadUrls.compactMap { URL(string: $0) }

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
