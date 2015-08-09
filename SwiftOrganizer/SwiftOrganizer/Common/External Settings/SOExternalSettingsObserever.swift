//
//  SOExternalSettingsObserever.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 8/9/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

// Before using this feature, you need to create the Settings.bundle in the Xcode. 
// For that add new file in Xcode, then select iOS - Resources - Settings.bundle

import Foundation

class SOExternalSettingsObserever{

    private class func prepareDefaultSettings() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let defaults = [ "AppTitle" : "SwiftOrganizer" ]
        userDefaults.registerDefaults(defaults)
        userDefaults.synchronize()
        //println(userDefaults.dictionaryRepresentation())
    }
    
    class func startObserver(){
        self.prepareDefaultSettings()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleSettingsChanged:", name: NSUserDefaultsDidChangeNotification, object: nil)
    }

    @objc class func handleSettingsChanged(notification: NSNotification){
        let userDefaults = NSUserDefaults.standardUserDefaults()

        if let name = userDefaults.stringForKey("name_preference"){
            println(name)
        }

        if let needUseRemoteDataBase = userDefaults.stringForKey("enabled_preference"){
            println(needUseRemoteDataBase)
        }
        
    }
    
    class func openTheSettingsApp(){
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
}

