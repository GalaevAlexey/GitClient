//
//  AppDelegate.swift
//  GitClient
//
//  Created by Alexey Galaev on 24/03/16.
//  Copyright © 2016 Alexey Galaev. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder {
    var window: UIWindow?
}

// MARK: handle callback url
extension AppDelegate {

    func applicationHandleOpenURL(url: NSURL) {
        if (url.host == "oauth-callback") {

        }
    }
}

// MARK: ApplicationDelegate
extension AppDelegate: UIApplicationDelegate {

    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
      return true
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

        return true
    }


    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        applicationHandleOpenURL(url)
        return true
    }

    @available(iOS 9.0, *)
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        applicationHandleOpenURL(url)
        return true
    }
}











