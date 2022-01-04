//
//  AppDelegate.swift
//  carypark
//
//  Created by Mac-Mini_2021 on 1/12/2021.
//

import UIKit
import CoreData
import GoogleSignIn
import Braintree
import FBSDKLoginKit
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppCenter.start(withAppSecret: "8403ec8d-c64e-4e86-92ad-bd3892c4bef5", services:[
          Analytics.self,
          Crashes.self
        ])
        // Override point for customization after application launch.
        
        // Paypal
        BTAppSwitch.setReturnURLScheme("tn.esprit.carypark.payments")
        
        // Facebook
        let facebook = ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        if (facebook){
            return true
        }
        
        // Google
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
            } else {
                // Show the app's signed-in state.
            }
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        if url.scheme?.localizedCaseInsensitiveCompare("tn.esprit.carypark.payments") == .orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
        }
        
        return false
    }
    
    
}
