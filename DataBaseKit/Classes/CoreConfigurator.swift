//
//  CoreConfigurator.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/11/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

public class CoreConfigurator {
    
    public class var sharedInstance: CoreConfigurator {
        struct SingletonWrapper {
            static let sharedInstance = CoreConfigurator()
        }
        
        return SingletonWrapper.sharedInstance;
    }
    
    public func configure()
    {

        UsersWorker.sharedInstance.usersStore = UsersCoreDataStore()  // UsersRemoteDataBase()
        LoginWorker.sharedInstance.login = LoginCoreData()  // LoginRemoteDataBase()
    }
    
}