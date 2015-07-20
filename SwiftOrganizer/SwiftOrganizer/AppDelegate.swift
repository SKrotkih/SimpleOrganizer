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
            
            if let sectionValue = section.toInt(){
                
                if let rowValue = row.toInt(){
                    return NSIndexPath(forRow: rowValue, inSection: sectionValue)
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
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.createMenuView()
        
        SOiCloudManager.sharedInstance.prepareKeyValueStoreObserver()
        
        // By Local Notifications this used
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))  // types are UIUserNotificationType properties
        if let localNotification: UILocalNotification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            println("Received notification \(localNotification.alertBody)!")
        }
        application.applicationIconBadgeNumber = 0;
        // 
        
        return SOParseComManager.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData){
        SOParseComManager.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        SOParseComManager.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        SOParseComManager.application(application, didReceiveRemoteNotification: userInfo)
    }
    
    //--------------------------------------
    // MARK: Local Notifications
    //--------------------------------------
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // Called when the user taps on a local notification (without selecting 
        // an action), or if a local notification arrives while using the app 
        // (in which case the notification isn't shown to the user)
        println("Received notification \(notification.alertBody)!")
        application.applicationIconBadgeNumber = 0;
    }

    // This function may be called when the app is in the background, if the 
    // action's activation mode was Background
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: (() -> Void)) {
            // Called when the user selects an action from a local notification
            println("Received \(notification.category)! Action: \(identifier)")
            // You must call this block when done dealing with the
            // action, or you'll be terminated
            completionHandler()
    }
    
    //-------------------------------------

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {

        if application.applicationState == UIApplicationState.Active {
            if let aps = userInfo["aps"] as? NSDictionary {
                if let alert = aps["alert"] as? NSDictionary {
                    if let message = alert["message"] as? NSString {
                        self.showAlertWithTitle("Remote message was received:", message: message as String)
                    }
                } else if let alert = aps["alert"] as? NSString {
                    self.showAlertWithTitle("Remote alert was received:", message: alert as String)
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
    
    //--------------------------------------
    // MARK: Facebook SDK Integration
    //--------------------------------------
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication srcApp: String?, annotation annot: AnyObject?) -> Bool {
        
        self.application(application, handleOpenURL: url)
        
        return SOParseComManager.application(application, openURL: url, sourceApplication: srcApp, annotation: annot)
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        if url.scheme == WidgetUrlScheme {
            
            let host = url.host!
            
            let index: String.Index = advance(KeyInURLAsSwitchDataBase.startIndex, count(KeyInURLAsSwitchDataBase))
            let key: String? = host.substringToIndex(index)

            if key == KeyInURLAsSwitchDataBase{
                var arr = split(host) {$0 == "."}

                if let index = arr[1].toInt(){
                    SOTypeDataBaseSwitcher.switchToIndex(index)
                }
            } else {
                /* Goes through our extension to convert
                String to NSIndexPath */
                let indexPath: NSIndexPath = host.toIndexPath()
                
                /* Now do your work with the index path */
                print(indexPath)
            }
        }
        
        return true
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
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        SODataBaseFactory.sharedInstance.dataBase.saveContext()
    }
    
    func showAlertWithTitle(title:String, message:String){
        self.mainViewController.showAlertWithTitle(title, message: message)
    }

}

