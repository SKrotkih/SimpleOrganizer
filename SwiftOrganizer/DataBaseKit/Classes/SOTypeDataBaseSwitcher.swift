//
//  SOTypeDataBaseSwitcher.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 7/16/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import Foundation

public enum DataBaseIndex: Int{
    case CoreDataIndex = 0
    case ParseComIndex
}

enum SODataBaseType: String{
    case Undefined = "Undefined"
    case CoreData = "LocalDataBase"
    case ParseCom = "ParseDataBase"
}

public class SOTypeDataBaseSwitcher{

    public class func switchToIndex(index: DataBaseIndex){
        let defaults = SOUserDefault.sharedDefaults()
        var dbType: String
        
        if index == .CoreDataIndex{
            dbType = SODataBaseType.CoreData.rawValue
        } else if index == .ParseComIndex{
            dbType = SODataBaseType.ParseCom.rawValue
        } else {
            return
        }
        
        defaults.setObject(dbType, forKey: SODataBaseTypeKey)
        defaults.synchronize()
        let notification = SOObserverNotification(type: .SODataBaseTypeChanged, data: dbType)
        SOObserversManager.sharedInstance.sendNotification(notification)
    }
    
    public class func setUpOfUsingICloud(usingICloud: Bool){
        let defaults = SOUserDefault.sharedDefaults()
        defaults.setBool(usingICloud, forKey: SOEnableiCloudForCoreDataKey)
        defaults.synchronize()
    }
    
    public class func usingICloudCurrentState() -> Bool{
        var retValue: Bool!
        let defaults = SOUserDefault.sharedDefaults()
        let useiCloudOpt: Bool? = defaults.boolForKey(SOEnableiCloudForCoreDataKey)
        
        if let useiCloud = useiCloudOpt{
            retValue = useiCloud
        } else {
            retValue = false
        }
        
        return retValue
    }
    
    public class func indexOfCurrectDBType() -> DataBaseIndex{
        var selectedIndex: DataBaseIndex!
        let defaults = SOUserDefault.sharedDefaults()
        
        if let name = defaults.stringForKey(SODataBaseTypeKey){

            switch name{
            case SODataBaseType.CoreData.rawValue:
                selectedIndex = .CoreDataIndex
            case SODataBaseType.ParseCom.rawValue:
                selectedIndex = .ParseComIndex
            default:
                selectedIndex = .CoreDataIndex
            }
        } else {
            selectedIndex = .CoreDataIndex
        }
        
        return selectedIndex
    }
    
    public class func switchToAnotherDB(){
        var currentIndex = self.indexOfCurrectDBType()

        switch currentIndex{
        case .CoreDataIndex:
            currentIndex = .ParseComIndex
        case .ParseComIndex:
            currentIndex = .CoreDataIndex
        default:
           currentIndex = .CoreDataIndex
        }

        self.switchToIndex(currentIndex)
    }
    
    public class func currectDataBaseDescription() -> String{
        var currentIndex = self.indexOfCurrectDBType()
        
        switch currentIndex{
        case .CoreDataIndex:
            return "Local".localized
        case .ParseComIndex:
            return "Remote".localized
        default:
            return "Local".localized
        }
    }
    
}

    // MARK: Internet Reachability Observer

extension SOTypeDataBaseSwitcher{
    
    public class func startInternetObserver(){
        SOReachabilityCenter.sharedInstance.startInternetObserver{ void in
            self.switchToLocalBaseIfNeeded()
        }
        
        self.switchToLocalBaseIfNeeded()        
    }
    
    private class func switchToLocalBaseIfNeeded(){
        if !SOReachabilityCenter.sharedInstance.isInternetConnected() && self.indexOfCurrectDBType() == .ParseComIndex{
            self.switchToIndex(.CoreDataIndex)
        }
    }
    
}
