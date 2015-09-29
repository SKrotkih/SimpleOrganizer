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
    
    public var name: String = ""
    public var isItCurrentUser: Bool = false
    
    convenience init(id: String, name: String, selected: Bool) {
        self.init()
        
        self.name = name
    }
    
    public var entityName: String{
        get{
            return UserEntityName
        }
    }
    
    public class func currentUser() -> SOUser{
        return SOUser()
    }
    
}
