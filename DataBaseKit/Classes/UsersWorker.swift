//
//  UsersWorker.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/10/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

protocol UsersStoreProtocol {
    var currentUser: User? { get set}
    func logInWithUserData(dict: Dictionary<String, AnyObject>)
}

public class UsersWorker: NSObject {
    var usersStore: UsersStoreProtocol?

    public class var sharedInstance: UsersWorker {
        struct SingletonWrapper {
            static let sharedInstance = UsersWorker()
        }
        
        return SingletonWrapper.sharedInstance;
    }
    
    public var currentUser: User?{
        get{
            return usersStore?.currentUser
        }
        set {
            usersStore?.currentUser = newValue
        }
    }

    public func logInWithUserData(dict: Dictionary<String, AnyObject>) {
        usersStore?.logInWithUserData(dict)
    }
    
}

