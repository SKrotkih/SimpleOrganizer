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


func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
    
    if let nav = base as? UINavigationController {
        return topViewController(base: nav.visibleViewController)
    }
    
    if let tab = base as? UITabBarController {
        if let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
    }
    
    if let presented = base?.presentedViewController {
        return topViewController(base: presented)
    }
    
    return base
}
