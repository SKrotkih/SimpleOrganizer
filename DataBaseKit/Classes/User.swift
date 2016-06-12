//
//  User.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

public class User: NSObject {
    var databaseObject: NSManagedObjectID?
    var firstname: String = ""
    var lastname: String = ""
    var gender: String = ""
    var email: String = ""
    var photo_prefix: String = ""
    var name: String = ""
    var fb_id: String = ""
    var userid: String = ""
    var isItCurrentUser: Bool = false
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
