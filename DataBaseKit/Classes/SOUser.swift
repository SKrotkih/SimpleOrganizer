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
    public var isItCurrentUser: Bool = false
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
    
    public func setUpLoggedInUserData(dict: Dictionary<String, AnyObject>){
        var managedObject: User!
        
        if let currentUser = self.user{
            if let theObject = self.coreData.managedObjectContext?.objectWithID(currentUser.databaseObject!) as? User{
                managedObject = theObject
            }
        }
        if managedObject == nil {
            managedObject = self.coreData.newManagedObject(UserEntityName) as! User
        }
        self.saveAsManagedObject(dict, managedObject: managedObject)
    }
    
    public var currentUser: SOUser?{
        get{
            if let currentUser = _currentUser{
                if currentUser.isItCurrentUser{
                    return currentUser
                }
            } else if let currentUser = self.user {
                if currentUser.isItCurrentUser{
                    return currentUser
                }
            }

            return nil
        }
        set {
            if let currentUser = newValue{
                if let managedObject = self.coreData.managedObjectContext?.objectWithID(currentUser.databaseObject!) as? User{
                    managedObject.currentUser = currentUser.isItCurrentUser
                    _currentUser = self.object(managedObject)
                    self.coreData.saveContext()
                }
            }
        }
    }

    lazy var usersFetchedResultController: NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: UserEntityName)
        request.sortDescriptors = []
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.coreData.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "users")
        return fetchedResultsController
        }()
    
    var user: SOUser?{
        do {
            try usersFetchedResultController.performFetch()

            if let objects = usersFetchedResultController.fetchedObjects
            {
                if objects.count > 0{
                    var currUser: SOUser?
                    let _ = objects.map({object in
                        let managedObject = object as! User
                        currUser = self.object(managedObject)
                    })
                    
                    return currUser
                }
            }
        } catch let error as NSError {
            print("Failed to fetch user data \(error)")
        }

        return nil
    }
    
    private func object(managedObject: User) -> SOUser{
        let object: SOUser = SOUser()
        object.databaseObject = managedObject.objectID
        object.firstname = managedObject.valueForKey("firstname") as! String
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

    private func saveAsManagedObject(dict: Dictionary<String, AnyObject>, managedObject: User){
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
        managedObject.currentUser = true
        
        self.coreData.saveContext()
    }
    
}
