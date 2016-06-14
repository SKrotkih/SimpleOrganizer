//
//  LoginRemoteDataBase.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/12/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

class LoginRemoteDataBase: LoginProtocol{

    func currentUserHasLoggedIn() -> Bool{
        return SOParseComManager.currentUserHasLoggedIn()
    }
    
    func logIn(viewController: UIViewController, completionBlock: (user: User?, error: NSError?) -> Void){
        
        SOParseComManager.logIn(viewController, completionBlock: {(error: NSError?) -> Void in
            completionBlock(user: nil, error: error)
        })
    }
    
    func logOut(viewController: UIViewController, completionBlock: (error: NSError?) -> Void){
        SOParseComManager.logOut(completionBlock)
    }
}
