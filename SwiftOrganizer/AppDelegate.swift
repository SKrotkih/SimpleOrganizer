//
//  AppDelegate.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/22/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainViewController: SOMainViewController!

    // MARK: -
    // MARK: didFinishLaunching
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        NSLog("\n\nDocument Directory: \n%@\n\n", self.applicationDocumentsDirectory)
        
        self.createOfSlidingViewControllers()
        
        SOTypeDataBaseSwitcher.startInternetObserver()
        
        SOiCloudManager.sharedInstance.prepareKeyValueStoreObserver()

        SOLocalNotificationsCenter.prepareLocalNotifications(application, launchOptions: launchOptions)
        
        SOExternalSettingsObserever.startObserver()
        
        var retBoolValue: Bool = SOParseComManager.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        retBoolValue = retBoolValue || FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        self.applicationIconBadgeNumber = 0
        
        Fabric.with([Crashlytics.self])
        
        return retBoolValue
    }

    // MARK: -
    // MARK: open URL
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication srcApp: String?, annotation annot: AnyObject) -> Bool {
        self.application(application, handleOpenURL: url)
        var isHandledOk: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: srcApp, annotation: annot)
        isHandledOk = isHandledOk || SOParseComManager.application(application, openURL: url, sourceApplication: srcApp, annotation: annot)
        
        return isHandledOk
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        if url.scheme == WidgetUrlScheme {
            self.todayWidgetHandleOpenURL(url)
        }
        
        return true
    }
    
    internal lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.domenicosolazzo.swift.Reading_data_from_CoreData" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
        }()
}

// MARK: -
// MARK: Application's life cycle

extension AppDelegate{
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
        self.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
}

// MARK: -
// MARK: Create of Sliding View Controllers

extension AppDelegate{
    private func createOfSlidingViewControllers() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        mainViewController = storyboard.instantiateViewControllerWithIdentifier("SOMainViewController") as! SOMainViewController
        let leftViewController = storyboard.instantiateViewControllerWithIdentifier("MainMenuViewController") as! MainMenuViewController
        let rightViewController = storyboard.instantiateViewControllerWithIdentifier("RightViewController") as! RightViewController
        
        let navigationController: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        leftViewController.mainViewController = navigationController
        
        let slideMenuController = SlideMenuController(  mainViewController: navigationController,
                                                        leftMenuViewController: leftViewController,
                                                        rightMenuViewController: rightViewController)
        
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    
}

// MARK: -
// MARK: Local Notifications

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

// MARK: -
// MARK: Push Notifications

extension AppDelegate{
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData){
        SOPushNotificationsCenter.didRegisterForRemoteNotificationsWithDeviceToken(application, deviceToken: deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        SOPushNotificationsCenter.didFailToRegisterForRemoteNotificationsWithError(application, error: error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        SOPushNotificationsCenter.didReceiveRemoteNotification(application, userInfo: userInfo)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        SOPushNotificationsCenter.didReceiveRemoteNotification(application, userInfo: userInfo, completionHandler: completionHandler)
    }
}

// MARK: -
// MARK: Today Widget

extension AppDelegate{

    private func todayWidgetHandleOpenURL(url:  NSURL){
        if let host = url.host{
            
            if NSString(string: host).containsString(WidgetDataKeys.KeyInURLAsSwitchDataBase) {
                var arr = host.characters.split {$0 == "."}.map { String($0) }
                
                if arr.count == 2{
                    if let index = Int(arr[1]){
                        SOTypeDataBaseSwitcher.switchToIndex(DataBaseIndex(rawValue: index)!)
                    }
                }
            } else if NSString(string: host).containsString(KeyInURLAsTaskId) {
                var arr = host.characters.split {$0 == "."}.map { String($0) }
                
                if arr.count == 2{
                    if let taskId: String = arr[1] as String{
                        print("Task Id = \(taskId)")
                    }
                }
                
            } else {
                
            }
        }
    }
    
}

extension AppDelegate{
    var applicationIconBadgeNumber: Int{
        get{
            return  UIApplication.sharedApplication().applicationIconBadgeNumber
        }
        set{
            if AppDelegate.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("8.0") {
                if UIApplication.sharedApplication().currentUserNotificationSettings()!.types.intersect(UIUserNotificationType.Badge) != [] {
                    UIApplication.sharedApplication().applicationIconBadgeNumber = newValue
                }
            } else {
                UIApplication.sharedApplication().applicationIconBadgeNumber = newValue
            }
        }
    }
}

    // MARK: -
    // MARK: System check

extension AppDelegate{
    class func SYSTEM_VERSION_EQUAL_TO(version: String) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version,
            options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedSame
    }
    
    class func SYSTEM_VERSION_GREATER_THAN(version: String) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version,
            options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedDescending
    }
    
    class func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version,
            options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedAscending
    }
    
    class func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version,
            options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedAscending
    }
    
    class func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version,
            options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedDescending
    }
}

    // MARK: -
    // MARK: Alert View Controller

extension AppDelegate{
    
    func showAlertWithTitle(title:String, message:String){
        self.mainViewController.showAlertWithTitle(title, message: message, addActions: nil, completionBlock: nil)
    }
}

