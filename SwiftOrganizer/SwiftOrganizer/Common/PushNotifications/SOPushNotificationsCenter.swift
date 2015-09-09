//
//  SOPushNotificationsCenter.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 8/6/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import Foundation

class SOPushNotificationsCenter: NSObject {

    class func didRegisterForRemoteNotificationsWithDeviceToken(application: UIApplication,  deviceToken: NSData){
        SOParseComManager.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    class func didFailToRegisterForRemoteNotificationsWithError(application: UIApplication, error: NSError) {
        SOParseComManager.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    class func didReceiveRemoteNotification(application: UIApplication, userInfo: [NSObject : AnyObject]) {
        SOParseComManager.application(application, didReceiveRemoteNotification: userInfo)
    }
    
    class func didReceiveRemoteNotification(application: UIApplication, userInfo: [NSObject : AnyObject], completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        if application.applicationState == UIApplicationState.Active {
            self.parseRemoteNotification(userInfo)
            completionHandler(UIBackgroundFetchResult.NewData)
        } else if application.applicationState == UIApplicationState.Inactive {
            println("Remote Notification was received in the Inactive mode of!");
            completionHandler(UIBackgroundFetchResult.NewData)
        } else if application.applicationState == UIApplicationState.Background {
            println("Remote Notification was received in the Background mode!");
            completionHandler(UIBackgroundFetchResult.NewData)
        }
        
        SOParseComManager.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
}

    // MARK: - Parse notification

extension SOPushNotificationsCenter{
    class func parseRemoteNotification(userInfo: [NSObject : AnyObject]){
        if let theAps = userInfo["aps"] as? NSDictionary {
            if let theAlert = theAps["alert"] as? NSDictionary {
                if let theMessage = theAlert["message"] as? NSString {
                    showAlertWithTitle("Remote message".localized, theMessage as String)
                }
            } else if let theMessage = theAps["alert"] as? NSString {
                showAlertWithTitle("Remote alert".localized, theMessage as String)
            }
        }
    }
}
