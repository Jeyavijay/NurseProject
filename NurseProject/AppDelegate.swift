//
//  AppDelegate.swift
//  NurseProject
//
//  Created by Jeyavijay on 15/09/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        IQKeyboardManager.sharedManager().enable = true

        deleteUserdefaultKeys()
        let settings = UIUserNotificationSettings(
            types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(settings)
        return true
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        UserDefaults.standard.set(tokenString, forKey: "DEVICETOKEN")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }

    func deleteUserdefaultKeys(){
        UserDefaults.standard.removeObject(forKey: "arrayEdu")
        UserDefaults.standard.removeObject(forKey: "arrayEduFile")
        
        UserDefaults.standard.removeObject(forKey: "arrayBLSBack")
        UserDefaults.standard.removeObject(forKey: "arrayBLSFront")
        
        UserDefaults.standard.removeObject(forKey: "arrayCertificate")
        UserDefaults.standard.removeObject(forKey: "arrayCertificateFileFront")
        UserDefaults.standard.removeObject(forKey: "arrayCertificateFileBack")
        UserDefaults.standard.removeObject(forKey: "arrayEmp")
        UserDefaults.standard.removeObject(forKey: "arrayRef")

    }

}
/*
 if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
 // iPad
 } else {
 // iPhone
 }
 */
