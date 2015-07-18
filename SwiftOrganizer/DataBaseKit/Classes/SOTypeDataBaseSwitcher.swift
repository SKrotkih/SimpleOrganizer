//
//  SOTypeDataBaseSwitcher.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 7/16/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import Foundation

class SOTypeDataBaseSwitcher{

    class func switchToIndex(index: Int){
        let defaults = NSUserDefaults.standardUserDefaults()
        var dbType: String
        
        if index == 0{
            dbType = SODataBaseType.CoreData.rawValue
        } else if index == 1{
            dbType = SODataBaseType.ParseCom.rawValue
        } else {
            return
        }
        
        defaults.setObject(dbType, forKey: SODataBaseTypeKey)
        defaults.synchronize()
        let notification: SOObserverNotification = SOObserverNotification(type: .SODataBaseTypeChanged, data: dbType)
        SOObserversManager.sharedInstance.sendNotification(notification)
    }
    
    class func setUpOfUsingICloud(usingICloud: Bool){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(usingICloud, forKey: SOEnableiCloudForCoreDataKey)
        defaults.synchronize()
    }
    
    class func usingICloudCurrentState() -> Bool{
        var retValue: Bool!
        let defaults = NSUserDefaults.standardUserDefaults()
        let useiCloudOpt: Bool? = defaults.boolForKey(SOEnableiCloudForCoreDataKey)
        
        if let useiCloud = useiCloudOpt{
            retValue = useiCloud
        } else {
            retValue = false
        }
        
        return retValue
    }
    
    class func indexOfCurrectDBType() -> Int{
        var selectedIndex: Int!
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let name = defaults.stringForKey(SODataBaseTypeKey){

            switch name{
            case SODataBaseType.CoreData.rawValue:
                selectedIndex = 0
            case SODataBaseType.ParseCom.rawValue:
                selectedIndex = 1
            default:
                selectedIndex = 0
            }
        } else {
            selectedIndex = 0
        }
        
        return selectedIndex
    }
    
    class func switchToAnotherDB(){
        var currentIndex = self.indexOfCurrectDBType()

        if currentIndex == 0{
           currentIndex = 1
        } else{
           currentIndex = 0
        }

        self.switchToIndex(currentIndex)
    }
}