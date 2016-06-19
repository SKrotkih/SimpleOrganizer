//
//  User.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 9/28/15.
//  Copyright © 2015 Sergey Krotkih. All rights reserved.
//

import Foundation
import CoreData

@objc(ManagedUser)
class ManagedUser: NSManagedObject {

    func toUser() -> User{
        let user: User = User()
        user.databaseObject = objectID
        
        let firstname = valueForKey("firstname") as? String
        
        user.firstname = firstname
        user.lastname = valueForKey("lastname") as? String
        user.gender = valueForKey("gender") as? String
        user.email = valueForKey("email") as? String
        user.photo_prefix = valueForKey("photo_prefix") as? String
        user.name = valueForKey("name") as? String
        user.fb_id = valueForKey("fb_id") as? String
        user.userid = valueForKey("userid") as? String
        user.isItCurrentUser = valueForKey("currentUser") as? Bool
        
        return user
    }
    
    func importDataFromDict(dict: Dictionary<String, AnyObject>){
        firstname = dict["first_name"] as? String
        lastname = dict["last_name"] as? String
        gender = dict["gender"] as? String
        email = dict["email"] as? String
        let picture: Dictionary<String, AnyObject> = dict["picture"] as! Dictionary<String, AnyObject>
        let picture_data: Dictionary<String, AnyObject>  = picture["data"] as! Dictionary<String, AnyObject>
        photo_prefix = picture_data["url"] as? String
        name = dict["name"] as? String
        fb_id = dict["id"] as? String
        userid = dict["id"] as? String
        currentUser = false
    }
    
    
}
