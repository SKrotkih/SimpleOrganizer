//
//  SOLocalNotificationsCenter.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 8/6/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import Foundation
import UIKit

class SOLocalNotificationsCenter: NSObject {
    
    private class func checkLocalNotifications(launchOptions: [NSObject: AnyObject]?){
        if let theNotification: UILocalNotification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            self.didReceiveLocalNotification(theNotification)
        }
    }
    
    class func prepareLocalNotifications(application: UIApplication, launchOptions: [NSObject: AnyObject]?){
        self.registerLocalNotificationsSettings(application, launchOptions: launchOptions)
        self.checkLocalNotifications(launchOptions)
    }
    
    // MARK: Register the Local Notifications
    
    private class func registerLocalNotificationsSettings(application: UIApplication, launchOptions: [NSObject: AnyObject]?) {
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))  // types are UIUserNotificationType properties
    }
    
    class func didRegisterUserNotificationSettings(notificationSettings: UIUserNotificationSettings){
        /* The user did not allow us to send notifications */
        let areAllowedTheLocalNotifications = notificationSettings.types != []
        self.setAreAllowedTheLocalNotifications(areAllowedTheLocalNotifications)
    }
    
    // MARK: The Local Notifications Handler
    
    class func didReceiveLocalNotification(notification: UILocalNotification) {

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let bundlesCount = appDelegate.applicationIconBadgeNumber - 1
        if bundlesCount >= 0{
            appDelegate.applicationIconBadgeNumber = bundlesCount
        }
        
        if let alertBody = notification.alertBody{
            if let userInfo = notification.userInfo{
                if let message = userInfo[self.kTaskIdKeyName()] as? String {
                    showAlertWithTitle("Reminder".localized, message: message)
                }
            } else {
                showAlertWithTitle("Notification".localized, message: alertBody)
            }
        }
        
    }
    
    // MARK: Send the Local Notifications
    
    class func sendLocalNotification(message: String, timeIntervalSinceNow: NSTimeInterval = 0, needToIncrementBadgeNumber: Bool = true, category: String? = nil) {
        if self.areAllowedTheLocalNotifications(){
            let localNotification = UILocalNotification()
            
            if let theCategory = category {
                localNotification.category = theCategory
            } else {
                localNotification.category = self.defaultCategory()
            }
            
            localNotification.alertBody = message
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            
            if needToIncrementBadgeNumber{
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                localNotification.applicationIconBadgeNumber = appDelegate.applicationIconBadgeNumber + 1;
            }
            
            if timeIntervalSinceNow == 0{
                application().presentLocalNotificationNow(localNotification)
            } else {
                localNotification.fireDate = NSDate(timeIntervalSinceNow: timeIntervalSinceNow);
                application().scheduleLocalNotification(localNotification)
            }
        }
    }

    class func sendScheduleNotification(message: String, date: NSDate, userInfo: [NSObject : AnyObject]? = nil, needToIncrementBadgeNumber: Bool = true, category: String? = nil) {
        if self.areAllowedTheLocalNotifications(){

            let localNotification = UILocalNotification()
            
            localNotification.fireDate = date
            localNotification.timeZone = NSCalendar.currentCalendar().timeZone

            if let theUserInfo = userInfo{
                localNotification.hasAction = true
                let alert = theUserInfo[self.kTaskIdKeyName()] as? String
                localNotification.alertAction = alert
                localNotification.alertBody = alert
                localNotification.userInfo = theUserInfo
            } else {
                localNotification.hasAction = false
                localNotification.alertBody = message
            }
            
            if needToIncrementBadgeNumber{
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                localNotification.applicationIconBadgeNumber = appDelegate.applicationIconBadgeNumber + 1;
            }

            application().scheduleLocalNotification(localNotification)
        }
    }
    
    // This function may be called when the app is in the background, if the
    // action's activation mode was Background
    class func handleActionForNotification(notification: UILocalNotification, identifier: String?){
        // Called when the user selects an action from a local notification
        print("Received \(notification.category)! Action: \(identifier)")
        // You must call this block when done dealing with the
        // action, or you'll be terminated
    }
    
}

    // MARK: Cancel the Local Notifications

extension SOLocalNotificationsCenter{
    class func cancelAllNotifications(){
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    class func cancelNotification(notification: UILocalNotification){
        UIApplication.sharedApplication().cancelLocalNotification(notification)
    }
}

    // MARK: Are Allowed The LocalNotifications? property

extension SOLocalNotificationsCenter{
    
    private class func setAreAllowedTheLocalNotifications(newValue: Bool){
        let userDefaults: NSUserDefaults = SOUserDefault.sharedDefaults()
        userDefaults.setBool(newValue, forKey: kAreAllowedTheLocalNotivicationsKey())
        userDefaults.synchronize()
    }
    
    private class func areAllowedTheLocalNotifications() -> Bool{
        let userDefaults: NSUserDefaults = SOUserDefault.sharedDefaults()
        let areAllowed: Bool? = userDefaults.boolForKey(kAreAllowedTheLocalNotivicationsKey())
        
        if let theareAllowed = areAllowed{
            return theareAllowed
        } else {
            return false
        }
    }
}

    // MARK: Utility

extension SOLocalNotificationsCenter{
    private class func application() -> UIApplication{
        return UIApplication.sharedApplication()
    }
}

// MARK: Constants

extension SOLocalNotificationsCenter{
    private class func defaultCategory() -> String{
        let bundleID = NSBundle.mainBundle().bundleIdentifier
        return "\(bundleID).message"
    }
    
    private class func kAreAllowedTheLocalNotivicationsKey() -> String{
        return "AreAllowedTheLocalNotivicationsKey"
    }
    
    class func kTaskIdKeyName() -> String{
        return "message"
    }
}
