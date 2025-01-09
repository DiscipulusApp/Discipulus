//
//  ShareViewController.swift
//  Share Extension
//
//  Created by Don Kuper on 20/02/2024.
//

import UIKit
import Social
import receive_sharing_intent

class ShareViewController: RSIShareViewController {
    
//    private func loadIds() {
//        let shareExtensionAppBundleIdentifier = "dev.harrydekat.discipulus";
//        let appGroupId = "group.dev.harrydekat.discipulus";
//    }
    
    override func shouldAutoRedirect() -> Bool {
        return true
    }

}
