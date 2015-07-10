//
//  SOUtilities.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/31/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import Foundation
import UIKit

func colorWithRGBHex(hex: UInt32) -> UIColor{
    let r: CGFloat = CGFloat((hex >> 16) & 0xFF);
    let g: CGFloat = CGFloat((hex >> 8) & 0xFF);
    let b: CGFloat = CGFloat((hex) & 0xFF);
    
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}

func showAlertWithTitle(title:String, message:String){
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    appDelegate.showAlertWithTitle(title, message: message)
}

func sendLocalNotification(message: String, timeIntervalSinceNow: NSTimeInterval = 0){
    var localNotification = UILocalNotification()
    localNotification.category = "com.skappledev.SwiftOrganizer.message"
    localNotification.alertBody = message
    localNotification.timeZone = NSTimeZone.defaultTimeZone()
    localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1;
    
    if timeIntervalSinceNow == 0{
        UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
    } else {
        localNotification.fireDate = NSDate(timeIntervalSinceNow: timeIntervalSinceNow);
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
//    You can use this func:
//    UIApplication.sharedApplication().cancelLocalNotification(aNotification)
//    UIApplication.sharedApplication().cancelAllLocalNotifications()
    
}

