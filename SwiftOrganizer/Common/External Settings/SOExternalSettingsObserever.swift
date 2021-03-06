//
//  SOExternalSettingsObserever.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 8/9/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

// Before using this feature, you need to create the Settings.bundle in the Xcode. 
// For that add a new file in Xcode, then select iOS - Resources - Settings.bundle

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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SOExternalSettingsObserever.handleSettingsChanged(_:)), name: NSUserDefaultsDidChangeNotification, object: nil)
    }

    @objc class func handleSettingsChanged(notification: NSNotification){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        // See enabled_preference id in Settings.bundle
        if let useRemoteDataBase = userDefaults.stringForKey("enabled_preference"),
            let newIndexOfDBType = Int(useRemoteDataBase){
                let indexOfCurrectDBType = SOTypeDataBaseSwitcher.currentDataBaseIndex().rawValue
                if newIndexOfDBType != indexOfCurrectDBType{
                    SOTypeDataBaseSwitcher.switchToNextDataBase()
                }
        }
    }
    
    class func openTheSettingsApp(){
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
}

