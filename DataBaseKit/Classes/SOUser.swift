//
//  SOUser.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import Parse

let UserEntityName = "User"

public class SOUser: NSObject {
    
    public var firstname: String = ""
    public var lastname: String = ""
    public var gender: String = ""
    public var email: String = ""
    public var photo_prefix: String = ""
    public var name: String = ""
    public var fb_id: String = ""
    public var isItCurrentUser: Bool = false
    
    public init(dict: Dictionary<String, AnyObject>){

        self.firstname = dict["first_name"] as! String
        self.lastname = dict["last_name"] as! String
        self.gender = dict["gender"] as! String
        self.email = dict["email"] as! String
        let picture: Dictionary<String, AnyObject> = dict["picture"] as! Dictionary<String, AnyObject>
        let picture_data: Dictionary<String, AnyObject>  = picture["data"] as! Dictionary<String, AnyObject>
        self.photo_prefix = picture_data["url"] as! String
        self.name = dict["name"] as! String
        self.fb_id = dict["id"] as! String
        self.isItCurrentUser = false
    }
    
    public var entityName: String{
        return UserEntityName
    }
    
    public class func currentUser() -> SOUser?{
        return nil
    }
    
}
