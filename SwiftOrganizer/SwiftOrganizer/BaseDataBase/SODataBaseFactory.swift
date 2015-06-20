//
//  SODataBaseFactory.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

let SODataBaseType = "DataBaseType"
let SOLocalDataBaseType = "LocalDataBase"
let SOParseDataBaseType = "ParseDataBase"

public class SODataBaseFactory: NSObject {

    private var _dataBase: SODataBaseProtocol?
    private var _dataBaseType: String = ""
    
    static let sharedInstance = SODataBaseFactory()

    var dataBase: SODataBaseProtocol!{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var dataBaseType: String = ""
        
        if let name = defaults.stringForKey(SODataBaseType)
        {
            dataBaseType = name
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
            case SOLocalDataBaseType:
                _dataBase = SOLocalDataBase()
            case SOParseDataBaseType:
                _dataBase = SORemoteDataBase()
            default:
                _dataBase = SOLocalDataBase()
                defaults.setObject(SOLocalDataBaseType, forKey: SODataBaseType)
            }
        }
        
        return _dataBase
    }
    
}
