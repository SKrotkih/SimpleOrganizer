//
//  SODataBaseFactory.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//
//  There is the Factory Method Pattern with using of the Chain Responsibility and of the Singleton patterns

import UIKit

public final class SODataBaseFactory {
    private let localDataBase: SOLocalDataBase
    private let remoteDataBase: SORemoteDataBase

    public class var sharedInstance: SODataBaseFactory {
        struct SingletonWrapper {
            static let sharedInstance = SODataBaseFactory()
        }
        return SingletonWrapper.sharedInstance;
    }
    
    private init() {
        remoteDataBase = SORemoteDataBase(nextDataBase: nil)
        localDataBase = SOLocalDataBase(nextDataBase: remoteDataBase)
    }

    public var dataBase: SODataBaseProtocol!{
        return localDataBase.chainResponsibility(SOTypeDataBaseSwitcher.currentDataBaseIndex())
    }
}
