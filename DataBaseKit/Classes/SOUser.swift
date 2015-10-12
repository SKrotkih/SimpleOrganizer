//
//  SOLocalUserManager.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import Parse

let DataBaseName = "LocalUsers"
let UserEntityName = "User"

public class SOUser: NSObject {
    public var databaseObject: NSManagedObject?
    public var firstname: String = ""
    public var lastname: String = ""
    public var gender: String = ""
    public var email: String = ""
    public var photo_prefix: String = ""
    public var name: String = ""
    public var fb_id: String = ""
    public var userid: String = ""
    public var isItCurrentUser: Bool = false
}

public class SOLocalUserManager: NSObject {
    private var coreData: SOCoreDataProtocol
    
    public var isItCurrentUser: Bool = false

    public class var sharedInstance: SOLocalUserManager {
        struct SingletonWrapper {
            static let sharedInstance = SOLocalUserManager()
        }
        return SingletonWrapper.sharedInstance;
    }

    override init() {
        self.coreData = SOCoreDataBase(dataBaseName: DataBaseName, options: nil, iCloudEnabled: false)
        
        super.init()
    }
    
    public func setUpLoggedInUserData(dict: Dictionary<String, AnyObject>){
        var userObject: User!
        
        if let currentUser = self.user{
            userObject = currentUser.databaseObject as! User
        } else {
            userObject = self.coreData.newManagedObject(UserEntityName) as! User
        }
        userObject.firstname = dict["first_name"] as? String
        userObject.lastname = dict["last_name"] as? String
        userObject.gender = dict["gender"] as? String
        userObject.email = dict["email"] as? String
        let picture: Dictionary<String, AnyObject> = dict["picture"] as! Dictionary<String, AnyObject>
        let picture_data: Dictionary<String, AnyObject>  = picture["data"] as! Dictionary<String, AnyObject>
        userObject.photo_prefix = picture_data["url"] as? String
        userObject.name = dict["name"] as? String
        userObject.fb_id = dict["id"] as? String
        userObject.userid = dict["id"] as? String
        userObject.currentUser = true
        
        self.coreData.saveContext()
    }
    
    public var currentUser: SOUser?{
        get{
            if let currentUser = self.user{
                if currentUser.isItCurrentUser{
                    return currentUser
                }
            }
            return nil
        }
        set {
            if let currentUser = newValue{
                let userObject = currentUser.databaseObject as? User
                userObject!.currentUser = currentUser.isItCurrentUser
                self.coreData.saveContext()
            }
        }
    }
    
    var user: SOUser?{
        let fetchRequest = NSFetchRequest(entityName: UserEntityName)
        let objects = (try! self.coreData.managedObjectContext!.executeFetchRequest(fetchRequest)) as! [User]
        if objects.count > 0{
            let currUser: SOUser = SOUser()
            objects.map({object in
                let theObject: User = object as User
                currUser.databaseObject = theObject
                currUser.firstname = theObject.valueForKey("firstname") as! String
                currUser.lastname = theObject.valueForKey("lastname") as! String
                currUser.gender = theObject.valueForKey("gender") as! String
                currUser.email = theObject.valueForKey("email") as! String
                currUser.photo_prefix = theObject.valueForKey("photo_prefix") as! String
                currUser.name = theObject.valueForKey("name") as! String
                currUser.fb_id = theObject.valueForKey("fb_id") as! String
                currUser.userid = theObject.valueForKey("userid") as! String
                currUser.isItCurrentUser = theObject.valueForKey("currentUser") as! Bool
            })
            
            return currUser
        }
        return nil
    }
    
    
}
