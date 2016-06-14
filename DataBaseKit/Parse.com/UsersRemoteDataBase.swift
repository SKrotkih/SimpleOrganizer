//
//  UsersRemoteDataBase.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/12/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation
import Bolts
import ParseFacebookUtilsV4
import ParseTwitterUtils
import Parse
import ParseUI

class UsersRemoteDataBase: UsersStoreProtocol {

    var currentUser: User? {
        get{
            if let currentUser = PFUser.currentUser(){
                let user: User = User()
                user.firstname = currentUser.username!
                user.name = currentUser.username!
                user.email = currentUser.email!
                user.photo_prefix = ""
                user.fb_id = ""
                user.userid = ""
                user.isItCurrentUser = true
                
                return user
            }
            return nil
        }
        set {
        }
    
    }
    
    func saveUserData(dict: Dictionary<String, AnyObject>){
        
    }

}