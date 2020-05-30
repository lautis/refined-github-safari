//
//  Settings.swift
//  Refined GitHub for Safari
//
//  Created by Ville Lautanala on 30.5.2020.
//  Copyright © 2020 Ville Lautanala. All rights reserved.
//

import Foundation
import KeychainAccess

class Settings {
    
    static let shared = Settings()
    private init() {}

    let personalTokenKey = "refinedGitHubForSafariPersonalToken"
    
    func bundleIdentifier() -> String {
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        if bundleIdentifier.hasSuffix("-extension") {
            return String(bundleIdentifier.dropLast("-extension".count)) + "-shared"
        } else {
            return bundleIdentifier + "-shared";
        }
    }
    
    func keychain() -> Keychain {
        Keychain(service: bundleIdentifier())
    }
    
    var personalToken: String {
        get {
            if let token = try? keychain().getString(personalTokenKey) {
                return token
            } else {
                return ""
            }
        }
        set(value) {
            do {
                try keychain()
                    .label("Refined GitHub for Safari GitHub Access Token")
                    .synchronizable(true)
                    .set(value, key: personalTokenKey)
            } catch let error {
                NSLog("error: \(error)")
            }
        }
    }
}
