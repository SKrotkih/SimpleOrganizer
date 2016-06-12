//
//  UsersConfigurator.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/11/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation


public class UsersConfigurator {
    
    public class var sharedInstance: UsersConfigurator {
        struct SingletonWrapper {
            static let sharedInstance = UsersConfigurator()
        }
        
        return SingletonWrapper.sharedInstance;
    }
    
    public func configure()
    {

        UsersWorker.sharedInstance.usersStore = UsersCoreDataStore()
        
    }
    
}