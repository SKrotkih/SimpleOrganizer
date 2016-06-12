//
//  UsersCoreDataStore.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/11/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

let DataBaseName = "LocalUsers"
let UserEntityName = "ManagedUser"
let FetchUsersDataCacheName = "users"

class UsersCoreDataStore: UsersStoreProtocol {

    private var coreData: SOCoreDataProtocol
    
    init() {
        self.coreData = SOCoreDataBase(dataBaseName: DataBaseName, options: nil, iCloudEnabled: false)
    }
    
    lazy var usersFetchedResultsController: NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: UserEntityName)
        request.sortDescriptors = []
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.coreData.managedObjectContext!, sectionNameKeyPath: nil, cacheName: FetchUsersDataCacheName)
        return fetchedResultsController
    }()
    
    private var managedUser: ManagedUser?{
        do {
            try usersFetchedResultsController.performFetch()
            
            if let objects = usersFetchedResultsController.fetchedObjects
            {
                if objects.count > 0{
                    let managedUser = objects[0] as? ManagedUser
                    return managedUser
                }
            }
        } catch let error as NSError {
            print("Failed to fetch user data \(error)")
        }
        
        return nil
    }
    
    var currentUser: User?{
        get{
            if let currentUser = self.managedUser?.toUser(){
                return currentUser.isItCurrentUser ? currentUser : nil
            }
            return nil
        }
        set {
            if let managedUser = self.managedUser {
                if let _ = newValue{
                    managedUser.currentUser = true
                } else {
                    managedUser.currentUser = false
                }
                self.coreData.saveContext()
            }
        }
    }
    
    func logInWithUserData(dict: Dictionary<String, AnyObject>){
        var managedUser: ManagedUser?
        if let theManagedObject = self.managedUser {
            managedUser = theManagedObject
        } else {
            managedUser = self.coreData.newManagedObject(UserEntityName) as? ManagedUser
        }
        managedUser?.importDataFromDict(dict)
        let user: User? = managedUser?.toUser()
        self.coreData.saveContext()
        self.currentUser = user
    }
    
}
