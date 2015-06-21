//
//  SODataBaseFactory.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

let SODataBaseTypeKey = "DataBaseType"

enum SODataBaseType: Int{
    case Undefined = 0
    case CoreData, ParseCom
    func toString() -> String{
        switch self{
        case .CoreData:
            return "LocalDataBase"
        case .ParseCom:
            return "ParseDataBase"
        case .Undefined:
            return "Undefined"
        }
    }
}

extension String{
    func dataBaseType() -> SODataBaseType{
        switch self{
        case "LocalDataBase":
            return .CoreData
        case "ParseDataBase":
            return .ParseCom
        default:
            return .Undefined
        }
    }
}

public class SODataBaseFactory: NSObject {
    private var _dataBase: SODataBaseProtocol?
    private var _dataBaseType: SODataBaseType = .Undefined
    
    static let sharedInstance = SODataBaseFactory()

    var dataBase: SODataBaseProtocol!{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var dataBaseType: SODataBaseType = .Undefined
        
        if let name = defaults.stringForKey(SODataBaseTypeKey)
        {
            dataBaseType = name.dataBaseType()
        }

        if dataBaseType != _dataBaseType{
            _dataBase = nil
        }
        
        if let dataBase = _dataBase{
            
        }
        else
        {
            _dataBaseType = dataBaseType
            
            switch _dataBaseType{
            case .CoreData:
                _dataBase = SOLocalDataBase()
            case .ParseCom:
                _dataBase = SORemoteDataBase()
            default:
                _dataBase = SOLocalDataBase()
                defaults.setObject(SODataBaseType.CoreData.toString(), forKey: SODataBaseTypeKey)
            }
        }
        
        return _dataBase
    }
    
}
