//
//  LoginInteractor.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/12/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import UIKit
import DataBaseKit

protocol LoginInteractorInput {
    func fetchUser()
    func logIn()
    func logOut()
    var user: User? { get }
}

class LoginInteractor: LoginInteractorInput {

    var output: LoginInteractorOutput!
    var viewController: UIViewController!
    var user: User?
    
    func fetchUser(){
        let user: User? = UsersWorker.sharedInstance.currentUser
        self.user = user
        self.output.presentFetchedUser(user)
    }
    
    func logIn(){
        LoginWorker.sharedInstance.viewController = self.viewController
        LoginWorker.sharedInstance.logIn{[weak self] (user: User?, error: NSError?) -> Void in
            if let theError = error{
                self!.showAlertWithTitle("Failed login to Parse.com!", message: "\(theError.localizedDescription)")
            } else {
                self!.user = user
                self!.output.presentFetchedUser(user)
            }
        }
    }
    
    func logOut(){
        if self.user == nil {
                return
        }
        
        LoginWorker.sharedInstance.viewController = self.viewController
        LoginWorker.sharedInstance.logOut{[weak self] (error: NSError?) -> Void in
            if let theError = error{
                self!.showAlertWithTitle("Failed logout from Parse.com!", message: "\(theError.localizedDescription)")
            } else {
                self!.user = nil
                self!.output.presentFetchedUser(nil)
            }
        }
    }
}

extension LoginInteractor{
    func showAlertWithTitle(title:String, message:String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        viewController.presentViewController(controller, animated: true, completion: nil)
    }
}
