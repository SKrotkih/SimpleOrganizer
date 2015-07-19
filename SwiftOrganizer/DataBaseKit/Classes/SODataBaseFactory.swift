//
//  SODataBaseFactory.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//
//  Factory Method Pattern implemented on this singleton

import UIKit

public let AppGroupsId = "group.skappleid.SOWidget"
public let SODataBaseTypeKey = "DataBaseType"
public let SOEnableiCloudForCoreDataKey = "EnableiCloudForCoreData"

enum SODataBaseType: String{
    case Undefined = "Undefined"
    case CoreData = "LocalDataBase"
    case ParseCom = "ParseDataBase"
}

public final class SODataBaseFactory: SOObserverProtocol {
    private var _dataBase: SODataBaseProtocol?

    public class var sharedInstance: SODataBaseFactory {
        struct SingletonWrapper {
        static let sharedInstance = SODataBaseFactory()
        }
        return SingletonWrapper.sharedInstance;
    }
    
    private init() {
        SOObserversManager.sharedInstance.addObserver(self, type: .SODataBaseTypeChanged, priority: 999)
    }

    deinit{
        SOObserversManager.sharedInstance.removeObserver(self, type: .SODataBaseTypeChanged)
    }
    
    public var dataBase: SODataBaseProtocol!{
        if _dataBase != nil{
            return _dataBase
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let name = defaults.stringForKey(SODataBaseTypeKey)
        {
            switch name{
            case SODataBaseType.CoreData.rawValue:
                _dataBase = SOLocalDataBase.sharedInstance()
            case SODataBaseType.ParseCom.rawValue:
                _dataBase = SORemoteDataBase.sharedInstance()
            default:
                _dataBase = defaultDataBase()
            }
        } else {
            _dataBase = defaultDataBase()
        }
        
        return _dataBase
    }

    private func defaultDataBase() -> SODataBaseProtocol{
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(SODataBaseType.CoreData.rawValue, forKey: SODataBaseTypeKey)
        
        return SOLocalDataBase.sharedInstance()
    }
    
    //- MARK: SOObserverProtocol implementation
    public func notify(notification: SOObserverNotification){
        switch notification.type{
        case .SODataBaseTypeChanged:
            self._dataBase = nil
        default:
            assert(false, "Something is wrong with observer code notification!")
        }
    }
}
