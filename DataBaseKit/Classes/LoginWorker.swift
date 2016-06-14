//
//  LoginWorker.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/12/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

public protocol LoginProtocol {
    func currentUserHasLoggedIn() -> Bool
    func logIn(viewController: UIViewController, completionBlock: (user: User?, error: NSError?) -> Void)
    func logOut(viewController: UIViewController, completionBlock: (error: NSError?) -> Void)
}

public class LoginWorker {
    public var login: LoginProtocol?
    public var viewController: UIViewController!
    
    public class var sharedInstance: LoginWorker {
        struct SingletonWrapper {
            static let sharedInstance = LoginWorker()
        }
        
        return SingletonWrapper.sharedInstance;
    }
    
    public func currentUserHasLoggedIn() -> Bool{
        return self.login!.currentUserHasLoggedIn()
    }
    
    public func logIn(completionBlock: (user: User?, error: NSError?) -> Void){
        self.login!.logIn(self.viewController, completionBlock: completionBlock)
    }

    public func logOut(completionBlock: (error: NSError?) -> Void){
        self.login!.logOut(self.viewController, completionBlock: completionBlock)
    }
    
}
