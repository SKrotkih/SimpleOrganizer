//
//  SODataBaseFactory.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//
// This Singleton implements of the Factory Method Pattern

import UIKit

let SODataBaseTypeKey = "DataBaseType"

enum SODataBaseType: String{
    case Undefined = "Undefined"
    case CoreData = "LocalDataBase"
    case ParseCom = "ParseDataBase"
}

public final class SODataBaseFactory: SOObserverProtocol {
    private var _dataBase: SODataBaseProtocol?

    class var sharedInstance: SODataBaseFactory {
        struct SingletonWrapper {
        static let sharedInstance = SODataBaseFactory()
        }
        return SingletonWrapper.sharedInstance;
    }
    
    private init() {
        SOObserversManager.sharedInstance.addObserver(self, type: .SODataBaseTypeChanged)
    }

    deinit{
        SOObserversManager.sharedInstance.removeObserver(self, type: .SODataBaseTypeChanged)
    }
    
    var dataBase: SODataBaseProtocol!{
        if _dataBase != nil{
            return _dataBase
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let name = defaults.stringForKey(SODataBaseTypeKey)
        {
            switch name{
            case SODataBaseType.CoreData.rawValue:
                _dataBase = SOLocalDataBase.sharedInstance
            case SODataBaseType.ParseCom.rawValue:
                _dataBase = SORemoteDataBase.sharedInstance
            default:
                _dataBase = defaultDataBase()
            }
        } else {
            _dataBase = defaultDataBase()
        }

        return _dataBase
    }

    //- MARK: SOObserverProtocol implementation
    func notify(notification: SOObserverNotification){
        switch notification.type{
        case .SODataBaseTypeChanged:
            self._dataBase = nil
        default:
            assert(false, "That observer type is absent!")
        }
    }

}

private func defaultDataBase() -> SODataBaseProtocol{
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setObject(SODataBaseType.CoreData.rawValue, forKey: SODataBaseTypeKey)

    return SOLocalDataBase.sharedInstance
}


    // MARK: - Example!
private let arrayQ = dispatch_queue_create("arrayQ", DISPATCH_QUEUE_SERIAL);

private func syncFunc(){
    
    dispatch_sync(arrayQ, {() in
//        self.data.append(item);
//        globalLogger.log(
        })
}
