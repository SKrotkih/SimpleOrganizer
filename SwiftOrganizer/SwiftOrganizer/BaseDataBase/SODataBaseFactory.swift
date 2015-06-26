//
//  SODataBaseFactory.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

let SODataBaseTypeKey = "DataBaseType"

enum SODataBaseType: String{
    case Undefined = "Undefined"
    case CoreData = "LocalDataBase"
    case ParseCom = "ParseDataBase"
}

public final class SODataBaseFactory {
    private var _dataBase: SODataBaseProtocol?

    class var sharedInstance: SODataBaseFactory {
        struct SingletonWrapper {
        static let sharedInstance = SODataBaseFactory()
        }
        return SingletonWrapper.sharedInstance;
    }
    
    private init() {
        
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
                _dataBase = SOLocalDataBase()
            case SODataBaseType.ParseCom.rawValue:
                _dataBase = SORemoteDataBase()
            default:
                _dataBase = defaultDataBase()
            }
        } else {
            _dataBase = defaultDataBase()
        }

        return _dataBase
    }
}

private func defaultDataBase() -> SODataBaseProtocol{
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setObject(SODataBaseType.CoreData.rawValue, forKey: SODataBaseTypeKey)

    return SOLocalDataBase()
}


    // MARK: - Example!
private let arrayQ = dispatch_queue_create("arrayQ", DISPATCH_QUEUE_SERIAL);

private func syncFunc(){
    
    dispatch_sync(arrayQ, {() in
//        self.data.append(item);
//        globalLogger.log(
        })
}
