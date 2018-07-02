//
//  AppDelegate.swift
//  SocialMedia
//
//  Created by Mansi Mahajan on 6/29/18.
//  Copyright © 2018 Mansi Mahajan. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import GoogleSignIn
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //1057967692586-fkkc0t5mkprp9bug34eknmj6g31q5jgd.apps.googleusercontent.com
    
    //276362666265653
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: "vL7yiVrv79K71APxzYUG1u5FS", consumerSecret: "a7R90Dlk2YPt3CNaHlHVSKfz4tVzy1ssvRlIPWZ9LNnt6EQjpS")
        
        // Override point for customization after application launch.
        return SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options) || GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation]) || TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
    
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

