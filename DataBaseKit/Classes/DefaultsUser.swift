//
//  DefaultsUser.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 7/19/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import Foundation

public class DefaultsUser{
    public class func sharedDefaults() -> NSUserDefaults{
        var sharedDefaults: NSUserDefaults!
        
        if let defaults = NSUserDefaults(suiteName: Defaults.AppGroupsId){
            sharedDefaults = defaults
        } else {
            sharedDefaults = NSUserDefaults.standardUserDefaults()
        }
        
        return sharedDefaults
    }
}
