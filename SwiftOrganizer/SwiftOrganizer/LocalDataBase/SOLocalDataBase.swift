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

class SOLocalDataBase: NSObject {
    
    static let sharedInstance = SOLocalDataBase()
    
    var _allTasks = [SOTask]()
    var _allCategories = [Category]()
    var _allIcons = [Ico]()
    
    //- MARK: Helper methods
    func populateTasks(){
        
        println("\(applicationDocumentsDirectory)")
        
        let entityName = NSStringFromClass(Task.classForCoder())
        let task  = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext!) as! Task
        
        task.category = "1"
        task.ico1 = "1"
        task.ico2 = "3"
        task.ico3 = "6"
        task.ico4 = "2"
        task.ico5 = ""
        task.ico6 = ""
        task.title = "Nask 1"


        let task2 = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext!) as! Task
        task2.category = "2"
        task2.ico1 = "6"
        task2.ico2 = "4"
        task2.ico3 = "3"
        task2.ico4 = "2"
        task2.ico5 = "1"
        task2.ico6 = ""
        task2.title = "Nask 2"

        let task3 = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext!) as! Task
        task3.category = "3"
        task3.ico1 = "10"
        task3.ico2 = "12"
        task3.ico3 = "3"
        task3.ico4 = "2"
        task3.ico5 = ""
        task3.ico6 = ""
        task3.title = "Nask 3"
        
        var savingError: NSError?
        if managedObjectContext!.save(&savingError){
            println("Managed to populate the database")
        } else {
            if let error = savingError{
                println("Failed to populate the database. Error = \(error)")
            }
        }
    }

    func populateIcons() -> Bool{
        let icons : [Dictionary<String, String>] = [["id":"1","name":"ico1","img":"ico1"],["id":"2","name":"ico2","img":"ico2"],["id":"3","name":"ico3","img":"ico3"],["id":"4","name":"ico4","img":"ico4"],
            ["id":"5","name":"ico5","img":"ico5"],["id":"6","name":"ico6","img":"ico6"],["id":"7","name":"ico7","img":"ico7"],["id":"8","name":"ico8","img":"ico8"],
            ["id":"9","name":"ico9","img":"ico9"],["id":"10","name":"ico10","img":"ico10"],["id":"11","name":"ico11","img":"ico11"],["id":"12","name":"ico12","img":"ico12"],
            ["id":"1","name":"ico1","img":"ico1"]]
        let entityName = NSStringFromClass(Ico.classForCoder())

        for dict in icons{
            let iconDict = dict as Dictionary<String, String>
            let ico = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext!) as! Ico
            ico.id = iconDict["id"]!
            ico.name = iconDict["name"]!
            ico.imagename = iconDict["img"]!
        }
        
        var savingError: NSError?
        
        if managedObjectContext!.save(&savingError){
            println("Managed to populate the database")
            
            return true
        } else {
            if let error = savingError{
                println("Failed to populate the database. Error = \(error)")
            }
            
            return false
        }
    }
    
    func populateCategories() -> Bool{
        let categories = ["ToDo", "Events", "Life", "Work"]
        var categoryId = 0
        let entityName = NSStringFromClass(Category.classForCoder())
        
        for catagoryName in categories{
            let category = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext!) as! Category
            category.id = "\(categoryId++)"
            category.name = catagoryName as String
        }
        var savingError: NSError?

        if managedObjectContext!.save(&savingError){
            println("Managed to populate the database")
            
            return true
        } else {
            if let error = savingError{
                println("Failed to populate the database. Error = \(error)")
            }
            
            return false
        }
    }

    // - MARK: Categories

    var allCategories: [Category]{
        get{

            if _allCategories.count > 0{
                return _allCategories
            }
            
            let fetchRequest = NSFetchRequest(entityName: "Category")
            
            var requestError: NSError?
            let categories = managedObjectContext!.executeFetchRequest(fetchRequest, error: &requestError) as! [Category]
            
            if categories.count > 0{
                for category in categories{
                    _allCategories.append(category)
                }
                
                return _allCategories
            } else {
                if populateCategories(){
                    return self.allCategories
                } else {
                    assert(false, "Failed to populate the database.")
                }
            }
        }
    }
    
    subscript(index: Int) -> Category  {
        assert(allCategories.count > 0 && index < allCategories.count)
        
        return allCategories[index]
    }
    
    func categoryForIndex(index: Int) -> Category{
        assert(allCategories.count > 0 && index < allCategories.count)
        
        return allCategories[index]
    }
    
    func categoryName(id : String) -> String{
        for category in self.allCategories{
            if category.id == id{
                return category.name
            }
        }
        
        return ""
    }

    // - MARK: Icons
    var allIcons: [Ico]{
        get{
            
            if _allIcons.count > 0{
                return _allIcons
            }
            
            let fetchRequest = NSFetchRequest(entityName: "Ico")
            
            var requestError: NSError?
            let icons = managedObjectContext!.executeFetchRequest(fetchRequest, error: &requestError) as! [Ico]
            
            if icons.count > 0{
                for ico in icons{
                    _allIcons.append(ico)
                }
                
                return _allIcons
            } else {
                if populateIcons(){
                    return self.allIcons
                } else {
                    assert(false, "Failed to populate the database.")
                }
            }
        }
    }
    
    func iconForIndex(index: Int) -> Ico{
        assert(allIcons.count > 0 && index < allIcons.count)
        
        return allIcons[index]
    }

    func iconsImageName(id : String) -> String{
        for ico in self.allIcons{
            if ico.id == id{
                return ico.imagename
            }
        }
        
        return ""
    }
    
    // - MARK: Tasks
    func fetchAllTasksInBackground(successBlock: (allTaskData: [SOTask], error: NSErrorPointer) -> Void) {
        let backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = persistentStoreCoordinator

        backgroundContext.performBlock{[weak self] in
            
            func fetchAllTasks() -> Bool{
                let fetchRequest = NSFetchRequest(entityName: "Task")
                var fetchError: NSError?
                let tasks = self!.managedObjectContext!.executeFetchRequest(fetchRequest, error: &fetchError) as! [Task]
                
                if fetchError == nil{
                    if tasks.count > 0 {
                        dispatch_async(dispatch_get_main_queue(), {
                            self!._allTasks.removeAll(keepCapacity: true)

                            for task in tasks{
                                let sotask = SOTask(task: task)
                                self!._allTasks.append(sotask)
                            }
                            var fetchError: NSError?
                            successBlock(allTaskData: self!._allTasks, error: &fetchError)
                        })
                        
                        return true
                    }
                    else {
                        return false
                    }
                } else {
                    println("Failed to execute the fetch request")
                    assert(false, "Failed to execute the fetch request")

                    return false
                }
            }

            if fetchAllTasks() == false {
                self!.populateTasks()
                
                fetchAllTasks()
            }
        }
    }
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.domenicosolazzo.swift.Reading_data_from_CoreData" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        
        println("\(DatabaseName)")
        
        let modelURL = NSBundle.mainBundle().URLForResource(DatabaseName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(DatabaseName).sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
}