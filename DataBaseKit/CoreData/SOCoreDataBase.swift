//
//  SOLocalDataBase.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import CoreData

let DatabaseName = "SwiftOrganizer"
let DataBaseErrorDomain = "SwiftOrganizerErrorDomain"

protocol SOCoreDataProtocol{
    var persistentStoreCoordinator: NSPersistentStoreCoordinator?{get}
    var managedObjectContext: NSManagedObjectContext?{get}
    func newManagedObject(entityName: String) -> NSManagedObject!
    func saveContext()
    func deleteObject(objectForDeleting: NSManagedObject?)

    func reportAnyErrorWeGot(error: NSError?)
    var applicationDocumentsDirectory: NSURL{get}
}

public class SOCoreDataBase: SOCoreDataProtocol {
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource(DatabaseName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    public lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        
        var options: Dictionary<String, String>? = nil
        
        if self.isiCloudEnabled(){
            options = [NSPersistentStoreUbiquitousContentNameKey: "Store"]
        }
        
        var persistentStoreDirectory: NSURL?
        
        if let directory = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(AppGroupsId){
            persistentStoreDirectory = directory
        } else {
            persistentStoreDirectory = self.applicationDocumentsDirectory
        }
        
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        if let url = persistentStoreDirectory?.URLByAppendingPathComponent("\(DatabaseName).sqlite"){
            var error: NSError? = nil
            do {
                try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
            } catch var error1 as NSError {
                error = error1
                coordinator = nil
                self.reportAnyErrorWeGot(error)
            } catch {
                fatalError()
            }
        } else {
            coordinator = nil
            var dict = [String: AnyObject]()
            let error: NSError? = NSError(domain: DataBaseErrorDomain, code: 9998, userInfo: dict)
            self.reportAnyErrorWeGot(error)
        }
        
        return coordinator
        }()
    
    public lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        if self.isiCloudEnabled(){
            self.subscribeToChangeStoreCoordinator(coordinator!)
        }
        
        return managedObjectContext
        }()
    
    public lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.domenicosolazzo.swift.Reading_data_from_CoreData" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
        }()

    
    private func subscribeToChangeStoreCoordinator(coordinator: NSPersistentStoreCoordinator){
        
        NSNotificationCenter.defaultCenter().addObserverForName(NSPersistentStoreDidImportUbiquitousContentChangesNotification,
            object: coordinator,
            queue: NSOperationQueue.mainQueue(),
            usingBlock: { (notification) in
                if let moc = self.managedObjectContext {
                    moc.mergeChangesFromContextDidSaveNotification(notification)
                    let notification: SOObserverNotification = SOObserverNotification(type: .SODataBaseDidChanged, data: nil)
                    SOObserversManager.sharedInstance.sendNotification(notification)
                }
        })
        
        NSNotificationCenter.defaultCenter().addObserverForName(NSPersistentStoreCoordinatorStoresWillChangeNotification,
            object: coordinator,
            queue: NSOperationQueue.mainQueue(),
            usingBlock: { (notification) in
                let notification: SOObserverNotification = SOObserverNotification(type: .SODataBaseDidChanged, data: nil)
                SOObserversManager.sharedInstance.sendNotification(notification)
        })
        
        NSNotificationCenter.defaultCenter().addObserverForName(NSPersistentStoreCoordinatorStoresDidChangeNotification,
            object: coordinator,
            queue: NSOperationQueue.mainQueue(),
            usingBlock: { (notification) in
                self.saveContext()
        })
        
    }
    
    public func newManagedObject(entityName: String) -> NSManagedObject!{
        //let entityName = NSStringFromClass(Task.classForCoder())
        let object  = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: self.managedObjectContext!) 
        
        return object
    }
    
}

// MARK: -
// MARK: - Update Data

extension SOCoreDataBase{
    public func deleteObject(objectForDeleting: NSManagedObject?)
    {
        if let moc = self.managedObjectContext {
            if let object = objectForDeleting{
                moc.deleteObject(object)
                self.saveContext()
            }
        }
    }
    
    public func saveContext() {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            
            if moc.hasChanges{
                
                do {
                    try moc.save()
                    moc.reset()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }
}


//- MARK: Other local functions

extension SOCoreDataBase{
    public func reportAnyErrorWeGot(error: NSError?){
        // Report any error we got.
        var dict = [String: AnyObject]()
        dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data".localized
        dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data.".localized
        dict[NSUnderlyingErrorKey] = error
        let error2 = NSError(domain: DataBaseErrorDomain, code: 9999, userInfo: dict)
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog("Unresolved error \(error2), \(error2.userInfo)")
        abort()
    }
    
    func isiCloudEnabled() -> Bool{
        let defaults = SOUserDefault.sharedDefaults()
        let useiCloudOpt: Bool? = defaults.boolForKey(DefaultsDataKeys.SOEnableiCloudForCoreDataKey)
        
        if let useiCloud = useiCloudOpt{
            return useiCloud
        }
        
        return false
    }
    
}
