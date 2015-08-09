//
//  AppDelegate.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/22/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

/* This is an extenstion on the String class that can convert a given
string with the format of %d-%d into an NSIndexPath */
extension String{
    func toIndexPath () -> NSIndexPath{
        let components = self.componentsSeparatedByString("-")
        
        if components.count == 2{
            let section = components[0]
            let row = components[1]
            
            if let theSection = section.toInt(){
                
                if let theRow = row.toInt(){
                    return NSIndexPath(forRow: theRow, inSection: theSection)
                }
            }
        }
        return NSIndexPath()
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainViewController: SOMainViewController!

    //--------------------------------------
    // MARK: didFinishLaunching
    //--------------------------------------
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.createMenuView()
        
        SOTypeDataBaseSwitcher.startInternetObserver()
        
        SOiCloudManager.sharedInstance.prepareKeyValueStoreObserver()

        SOLocalNotificationsCenter.prepareLocalNotifications(application, launchOptions: launchOptions)
        
        application.applicationIconBadgeNumber = 0;
        
        SOExternalSettingsObserever.startObserver()
        
        return SOParseComManager.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    //--------------------------------------
    // MARK: open URL
    //--------------------------------------
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication srcApp: String?, annotation annot: AnyObject?) -> Bool {
        
        self.application(application, handleOpenURL: url)
        
        return SOParseComManager.application(application, openURL: url, sourceApplication: srcApp, annotation: annot)
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        if url.scheme == WidgetUrlScheme {
            self.todayWidgetHandleOpenURL(url)
        }
        
        return true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        application.applicationIconBadgeNumber = 0;        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        SODataBaseFactory.sharedInstance.dataBase.saveContext()
    }
}

//--------------------------------------
// MARK: Create Menu
//--------------------------------------

extension AppDelegate{
    private func createMenuView() {
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        mainViewController = storyboard.instantiateViewControllerWithIdentifier("SOMainViewController") as! SOMainViewController
        let leftViewController = storyboard.instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
        let rightViewController = storyboard.instantiateViewControllerWithIdentifier("RightViewController") as! RightViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
        
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    
}

//--------------------------------------
// MARK: Local Notifications
//--------------------------------------

extension AppDelegate{
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings){
        SOLocalNotificationsCenter.didRegisterUserNotificationSettings(notificationSettings)
    }
    
    // Called when the user taps on a local notification (without selecting an action), or if a local notification
    // arrives while using the app (in which case the notification isn't shown to the user)
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        SOLocalNotificationsCenter.didReceiveLocalNotification(notification)
    }
    
    // This function may be called when the app is in the background, if the
    // action's activation mode was Background
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: (() -> Void)) {
        SOLocalNotificationsCenter.handleActionForNotification(notification, identifier: identifier)
        completionHandler()
    }
}

//--------------------------------------
// MARK: Push Notifications
//--------------------------------------

extension AppDelegate{
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData){
        SOParseComManager.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        SOParseComManager.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        SOParseComManager.application(application, didReceiveRemoteNotification: userInfo)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        if application.applicationState == UIApplicationState.Active {
            if let theAps = userInfo["aps"] as? NSDictionary {
                if let theAlert = theAps["alert"] as? NSDictionary {
                    if let theMessage = theAlert["message"] as? NSString {
                        self.showAlertWithTitle("Remote message was received:", message: theMessage as String)
                    }
                } else if let theMessage = theAps["alert"] as? NSString {
                    self.showAlertWithTitle("Remote alert was received:", message: theMessage as String)
                }
            }
            completionHandler(UIBackgroundFetchResult.NewData)
        } else if application.applicationState == UIApplicationState.Inactive {
            println("Inactive");
            completionHandler(UIBackgroundFetchResult.NewData)
        } else if application.applicationState == UIApplicationState.Background {
            println("Background");
            completionHandler(UIBackgroundFetchResult.NewData)
        }
        
        SOParseComManager.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
}

extension AppDelegate{

    private func todayWidgetHandleOpenURL(url:  NSURL){
        if let host = url.host{
            
            if NSString(string: host).containsString(KeyInURLAsSwitchDataBase) {
                var arr = split(host) {$0 == "."}
                
                if arr.count == 2{
                    if let index = arr[1].toInt(){
                        SOTypeDataBaseSwitcher.switchToIndex(DataBaseIndex(rawValue: index)!)
                    }
                }
            } else if NSString(string: host).containsString(KeyInURLAsTaskId) {
                var arr = split(host) {$0 == "."}
                
                if arr.count == 2{
                    if let taskId = arr[1] as? String{
                        println("Task Id = \(taskId)")
                    }
                }
                
            } else {
                
            }
        }
    }
    
}


//--------------------------------------
// MARK: Utility
//--------------------------------------

extension AppDelegate{
    
    func showAlertWithTitle(title:String, message:String){
        self.mainViewController.showAlertWithTitle(title, message: message)
    }
}
