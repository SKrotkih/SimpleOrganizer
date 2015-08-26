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
public let KeyInURLAsSwitchDataBase = "switchdbto."
public let KeyInURLAsTaskId = "taskid."
public let WidgetUrlScheme = "widget"

public final class SODataBaseFactory {
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
        
        let dataBaseIndex: DataBaseIndex =  SOTypeDataBaseSwitcher.indexOfCurrectDBType()
        
        switch dataBaseIndex{
        case .CoreDataIndex:
            _dataBase = SOLocalDataBase.sharedInstance()
        case .ParseComIndex:
            _dataBase = SORemoteDataBase.sharedInstance()
        }
        
        return _dataBase
    }
}

extension SODataBaseFactory: SOObserverProtocol {
    public func notify(notification: SOObserverNotification){
        switch notification.type{
        case .SODataBaseTypeChanged:
            self._dataBase = nil
        default:
            assert(false, "Something is wrong with observer code notification!")
        }
    }
}
