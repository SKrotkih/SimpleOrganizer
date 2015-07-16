//
//  SOTaskMenuItemActivity.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

typealias SOClosureForActivityType = () -> ()

class SOTaskMenuItemActivity: UIActivity {
    
    var performBlock: SOClosureForActivityType?
    var name: String?
    var title: String?
    var imageName: String?
    
    override func activityTitle() -> String {
        return self.title!
    }
    
    override func activityImage() -> UIImage {
        return UIImage(named: self.imageName!)!
    }
    
    override func performActivity() {
        if let realBlock = performBlock{
            realBlock()
        }
    }
    
    override func activityType() -> String {
        return NSBundle.mainBundle().bundleIdentifier! + "." + self.name!
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return true
    }
    
    override func prepareWithActivityItems(paramActivityItems: [AnyObject]) {
    }
}
