//
//  LoginCoreData.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/12/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

class LoginCoreData: LoginProtocol{
    
    func currentUserHasLoggedIn() -> Bool{
        return AILogInManager.sharedInstance().isCurrentUserAlreadyLoggedIn()
    }
    
    func logIn(viewController: UIViewController, completionBlock: (user: User?, error: NSError?) -> Void){
        if self.currentUserHasLoggedIn(){
            let currentUser: User? = UsersWorker.sharedInstance.currentUser
            completionBlock(user: currentUser, error: nil)
        } else {
            AILogInManager.sharedInstance().logInViaFacebookWithViewControoler(viewController, completionBlock: {(loginState: AILoginState) in
                if loginState == OperationIsRanSuccessfully{
                    let currentUser: User? = UsersWorker.sharedInstance.currentUser
                    completionBlock(user: currentUser, error: nil)
                } else {
                    var dict = [String: AnyObject]()
                    dict[NSLocalizedDescriptionKey] = "Failed to Log In via Facebook".localized
                    dict[NSLocalizedFailureReasonErrorKey] = "Failed to Log In via Facebook".localized
                    let error2 = NSError(domain: DataBaseErrorDomain, code: 9999, userInfo: dict)
                    completionBlock(user: nil, error: error2)
                }
            })
        }
    }
    
    func logOut(viewController: UIViewController, completionBlock: (error: NSError?) -> Void){
        AILogInManager.sharedInstance().logOutAlertWithViewController(viewController,  completionBlock: {() in
            completionBlock(error: nil)
        })
    }
}


