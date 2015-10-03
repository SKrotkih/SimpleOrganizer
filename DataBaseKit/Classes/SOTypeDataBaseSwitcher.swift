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
    
    func localizedDescription() -> String{
        switch self{
        case CoreDataIndex:
            return "Local".localized
        case ParseComIndex:
            return "Remote".localized
        }
    }
    
    func nextDataBaseIndex() -> DataBaseIndex{
        switch self{
        case CoreDataIndex:
            return ParseComIndex
        case ParseComIndex:
            return CoreDataIndex
        }
    }
    
    static func localDataBaseIndex() -> DataBaseIndex{
        return CoreDataIndex
    }
    
}

enum SODataBaseType: String{
    case Undefined = "Undefined"
    case CoreData = "LocalDataBase"
    case ParseCom = "ParseDataBase"
    
    static func nameByIndex(dataBaseIndex: DataBaseIndex) -> String{
        var dataBaseName = SODataBaseType.CoreData.rawValue
        
        switch dataBaseIndex{
        case .CoreDataIndex:
            dataBaseName = SODataBaseType.CoreData.rawValue
        case .ParseComIndex:
            dataBaseName = SODataBaseType.ParseCom.rawValue
        }

        return dataBaseName
    }
    
    static func indexByName(name: String?) -> DataBaseIndex{
        var index: DataBaseIndex = .CoreDataIndex
        
        if name == nil || name == SODataBaseType.CoreData.rawValue{
            index = .CoreDataIndex
        } else if name == SODataBaseType.ParseCom.rawValue{
            index = .ParseComIndex
        }
        
        return index
    }
}

public class SOTypeDataBaseSwitcher{

    public class func currentDataBaseIndex() -> DataBaseIndex{
        let defaults = SOUserDefault.sharedDefaults()
        return SODataBaseType.indexByName(defaults.stringForKey(DefaultsDataKeys.SODataBaseTypeKey))
    }
    
    public class func switchToIndex(newDataBaseIndex: DataBaseIndex){
        let newDataBaseName: String = SODataBaseType.nameByIndex(newDataBaseIndex)
        
        if newDataBaseIndex != self.currentDataBaseIndex(){
            let defaults = SOUserDefault.sharedDefaults()
            defaults.setObject(newDataBaseName, forKey: DefaultsDataKeys.SODataBaseTypeKey)
            defaults.synchronize()
        }
        
        let notification = SOObserverNotification(type: .SODataBaseTypeChanged, data: newDataBaseName)
        SOObserversManager.sharedInstance.sendNotification(notification)
    }
    
    public class func switchToNextDataBase(){
        let currentDataBaseIndex = self.currentDataBaseIndex()
        let newDataBaseIndex = currentDataBaseIndex.nextDataBaseIndex()
        self.switchToIndex(newDataBaseIndex)
    }
    
    public class func currectDataBaseDescription() -> String{
        let currentDataBaseIndex = self.currentDataBaseIndex()
        return currentDataBaseIndex.localizedDescription()
    }
}

    // MARK: - iCloud

extension SOTypeDataBaseSwitcher{
    
    public class func setUpOfUsingICloud(usingICloud: Bool){
        let defaults = SOUserDefault.sharedDefaults()
        defaults.setBool(usingICloud, forKey: DefaultsDataKeys.SOEnableiCloudForCoreDataKey)
        defaults.synchronize()
    }
    
    public class func usingICloudCurrentState() -> Bool{
        var retValue: Bool!
        let defaults = SOUserDefault.sharedDefaults()
        let useiCloudOpt: Bool? = defaults.boolForKey(DefaultsDataKeys.SOEnableiCloudForCoreDataKey)
        
        if let useiCloud = useiCloudOpt{
            retValue = useiCloud
        } else {
            retValue = false
        }
        
        return retValue
    }
}

    // MARK: - Internet Reachability Observer

extension SOTypeDataBaseSwitcher{
    
    public class func startInternetObserver(){
        SOReachabilityCenter.sharedInstance.startInternetObserver{ void in
            self.switchToLocalBaseIfNeeded()
        }
        
        self.switchToLocalBaseIfNeeded()        
    }
    
    private class func switchToLocalBaseIfNeeded(){
        if !SOReachabilityCenter.sharedInstance.isInternetConnected() && self.currentDataBaseIndex() != DataBaseIndex.localDataBaseIndex(){
            self.switchToIndex(DataBaseIndex.localDataBaseIndex())
        }
    }
    
}
