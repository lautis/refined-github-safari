//
//  SafariExtensionViewController.swift
//  Refined Github Extension
//
//  Created by Ville Lautanala on 17/02/2019.
//  Copyright © 2019 Ville Lautanala. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()

}
