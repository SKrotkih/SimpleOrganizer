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
    public var databaseObject: NSManagedObjectID?
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
    private var _currentUser: SOUser?

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
    
    lazy var usersFetchedResultsController: NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: UserEntityName)
        request.sortDescriptors = []
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.coreData.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "users")
        return fetchedResultsController
        }()

    private var managedObject: User?{
        do {
            try usersFetchedResultsController.performFetch()
            
            if let objects = usersFetchedResultsController.fetchedObjects
            {
                if objects.count > 0{
                    let managedObject = objects[0] as? User
                    return managedObject
                }
            }
        } catch let error as NSError {
            print("Failed to fetch user data \(error)")
        }
        
        return nil
    }
    
    var user: SOUser?{
        if let managedObject = self.managedObject {
            return self.createObject(managedObject)
        }
        return nil
    }
    
    public func logInWithFacebookUserData(dict: Dictionary<String, AnyObject>){
        var managedObject: User?
        if let theManagedObject = self.managedObject {
            managedObject = theManagedObject
        } else {
            managedObject = self.coreData.newManagedObject(UserEntityName) as? User
        }
        self.saveDataToManagedObject(dict, managedObject: &managedObject!)
        let user: SOUser = self.createObject(managedObject!)
        self.coreData.saveContext()
        self.currentUser = user
    }
    
    public var currentUser: SOUser?{
        get{
            var currentUser: SOUser?
            
            if let theCurrentUser = _currentUser{
                currentUser = theCurrentUser
            } else if let theCurrentUser = self.user {
                currentUser = theCurrentUser
            } else {
                return nil
            }
            return currentUser!.isItCurrentUser ? currentUser : nil
        }
        set {
            if let managedObject = self.managedObject {
                if let _ = newValue{
                    managedObject.currentUser = true
                } else {
                    managedObject.currentUser = false
                }
                _currentUser = self.createObject(managedObject)
                self.coreData.saveContext()
            }
        }
    }
    
    private func createObject(managedObject: User) -> SOUser{
        let object: SOUser = SOUser()
        object.databaseObject = managedObject.objectID
        
        let firstname = managedObject.valueForKey("firstname") as! String
        
        object.firstname = firstname
        object.lastname = managedObject.valueForKey("lastname") as! String
        object.gender = managedObject.valueForKey("gender") as! String
        object.email = managedObject.valueForKey("email") as! String
        object.photo_prefix = managedObject.valueForKey("photo_prefix") as! String
        object.name = managedObject.valueForKey("name") as! String
        object.fb_id = managedObject.valueForKey("fb_id") as! String
        object.userid = managedObject.valueForKey("userid") as! String
        object.isItCurrentUser = managedObject.valueForKey("currentUser") as! Bool

        return object
    }

    private func saveDataToManagedObject(dict: Dictionary<String, AnyObject>, inout managedObject: User){
        managedObject.firstname = dict["first_name"] as? String
        managedObject.lastname = dict["last_name"] as? String
        managedObject.gender = dict["gender"] as? String
        managedObject.email = dict["email"] as? String
        let picture: Dictionary<String, AnyObject> = dict["picture"] as! Dictionary<String, AnyObject>
        let picture_data: Dictionary<String, AnyObject>  = picture["data"] as! Dictionary<String, AnyObject>
        managedObject.photo_prefix = picture_data["url"] as? String
        managedObject.name = dict["name"] as? String
        managedObject.fb_id = dict["id"] as? String
        managedObject.userid = dict["id"] as? String
        managedObject.currentUser = false
    }
    
}
