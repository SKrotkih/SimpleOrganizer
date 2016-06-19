//
//  User.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

public class User: NSObject {
    public var databaseObject: NSManagedObjectID?
    public var firstname: String?
    public var lastname: String?
    public var gender: String?
    public var email: String?
    public var photo_prefix: String?
    public var name: String?
    public var fb_id: String?
    public var userid: String?
    public var isItCurrentUser: Bool?
    
    override init(){
        databaseObject = nil
        firstname = ""
        lastname = ""
        gender = ""
        email = ""
        photo_prefix = ""
        name = ""
        fb_id = ""
        userid = ""
        isItCurrentUser = false
    }
    
}

public func ==(lhs: User, rhs: User) -> Bool
{
    return lhs.databaseObject == rhs.databaseObject
        && lhs.firstname == rhs.firstname
        && lhs.lastname == rhs.lastname
        && lhs.gender == rhs.gender
        && lhs.email == rhs.email
        && lhs.photo_prefix == rhs.photo_prefix
        && lhs.name == rhs.name
        && lhs.fb_id == rhs.fb_id
        && lhs.userid == rhs.userid
        && lhs.isItCurrentUser == rhs.isItCurrentUser
}
