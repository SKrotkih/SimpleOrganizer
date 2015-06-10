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

public class SOLocalDataBase: NSObject {
    
    static let sharedInstance = SOLocalDataBase()
    
    lazy var _allTasks = [SOTask]()
    lazy var _allCategories = [Category]()
    lazy var _allIcons = [Ico]()
    
    //- MARK: Helper methods
    func newTaskManagedObject() -> Task!{
        let entityName = NSStringFromClass(Task.classForCoder())
        let task  = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext!) as! Task
        
        return task
    }
    
    private func populateTasks(){
        
        println("\(applicationDocumentsDirectory)")
        
        let task  = self.newTaskManagedObject()
        task.category = "1"
        task.ico1 = "1"
        task.ico2 = "3"
        task.ico3 = "6"
        task.ico4 = "2"
        task.ico5 = ""
        task.ico6 = ""
        task.title = "ToDo task"


        let task2  = self.newTaskManagedObject()
        task2.category = "2"
        task2.ico1 = "6"
        task2.ico2 = "4"
        task2.ico3 = "3"
        task2.ico4 = "2"
        task2.ico5 = "1"
        task2.ico6 = ""
        task2.title = "Event task"

        let task3  = self.newTaskManagedObject()
        task3.category = "3"
        task3.ico1 = "10"
        task3.ico2 = "12"
        task3.ico3 = "3"
        task3.ico4 = "2"
        task3.ico5 = ""
        task3.ico6 = ""
        task3.title = "Life task"

        let task4  = self.newTaskManagedObject()
        task4.category = "4"
        task4.ico1 = "1"
        task4.ico2 = "17"
        task4.ico3 = ""
        task4.ico4 = "2"
        task4.ico5 = ""
        task4.ico6 = ""
        task4.title = "Work task"
        
        saveContext()
    }

    private func populateIcons(){
        let icons : [Dictionary<String, String>] = [["id":"1","name":"ico1","img":"ico1"],
            ["id":"2","name":"ico2","img":"ico2"],
            ["id":"3","name":"ico3","img":"ico3"],
            ["id":"4","name":"ico4","img":"ico4"],
            ["id":"5","name":"ico5","img":"ico5"],
            ["id":"6","name":"ico6","img":"ico6"],
            ["id":"7","name":"ico7","img":"ico7"],
            ["id":"8","name":"ico8","img":"ico8"],
            ["id":"9","name":"ico9","img":"ico9"],
            ["id":"10","name":"ico10","img":"ico10"],
            ["id":"11","name":"ico11","img":"ico11"],
            ["id":"12","name":"ico12","img":"ico12"],
            ["id":"13","name":"ico13","img":"ico13"],
        ["id":"14","name":"ico14","img":"ico14"],
        ["id":"15","name":"ico15","img":"ico15"],
        ["id":"16","name":"ico16","img":"ico16"],
        ["id":"17","name":"ico17","img":"ico17"]]
        let entityName = NSStringFromClass(Ico.classForCoder())

        for dict in icons{
            let ico = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext!) as! Ico
            ico.id = dict["id"]!
            ico.name = dict["name"]!
            ico.imagename = dict["img"]!
            ico.selected = true
        }

        saveContext()
    }
    
    private func populateCategories(){
        let categories = ["ToDo".localized, "Events".localized, "Life".localized, "Work".localized]
        var categoryId = 1
        let entityName = NSStringFromClass(Category.classForCoder())
        
        for catagoryName in categories{
            let category = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext!) as! Category
            let newCategoryId = "\(categoryId++)"
            category.id = newCategoryId
            category.name = catagoryName as String
            category.selected = true
        }
        
        saveContext()
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
            
            if let error = requestError{
                println("Failed to fetch of Category data. Error = \(error)")
            }
            
            if categories.count > 0{
                for category in categories{
                    
                    println("\(category.id)")
                    
                    _allCategories.append(category)
                }
                
                return _allCategories
            } else {
                populateCategories()

                return self.allCategories
            }
        }
    }
    
    func updateCategory(category: Category, fieldName: String, value: AnyObject){
        _allCategories.removeAll(keepCapacity: false)
        category.setValue(value, forKey: fieldName);
        self.saveContext()
    }

    func updateIcon(icon: Ico, fieldName: String, value: AnyObject){
        _allIcons.removeAll(keepCapacity: false)
        icon.setValue(value, forKey: fieldName);
        self.saveContext()
    }

    func updateTask(){
        //       let batch = NSBatchUpdateRequest(entityName: "Category")
        //        batch.propertiesToUpdate = [fieldName: value]
        //        // Predicate
        //        batch.predicate = NSPredicate(format: "id = %@", category.id)
        //        // Result type
        //        batch.resultType = NSBatchUpdateRequestResultType.UpdatedObjectsCountResultType
        //
        //        var batchError: NSError?
        //        let result = managedObjectContext!.executeRequest(batch, error: &batchError)
        //
        //        if result != nil{
        //            if let theResult = result as? NSBatchUpdateResult{
        //                if let numberOfAffectedPersons = theResult.result as? Int{
        //                    println("Number of categories which were updated is \(numberOfAffectedPersons)")
        //                }
        //            }
        //        }else{
        //            if let error = batchError{
        //                println("Could not perform batch request. Error = \(error)")
        //            }
        //        }
    }
    
    subscript(index: Int) -> Category? {
        if allCategories.count > 0 && index < allCategories.count{
            return allCategories[index]
        }
        
        return nil
    }
    
    func categoryForIndex(index: Int) -> Category?{
        if allCategories.count > 0 && index < allCategories.count{
            return allCategories[index]
        }
        
        return nil
    }
    
    func categoryName(id : String) -> String?{
        if let category = self.categoryById(id){
            return category.name
        }
        
        return nil
    }

    func categoryById(id : String) -> Category?{
        for category in self.allCategories{
            if category.id == id{
                return category
            }
        }
        
        return nil
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
            
            if let error = requestError{
                println("Failed to fetch of Icons data. Error = \(error)")

                abort()
            }
            
            if icons.count > 0{
                for ico in icons{
                    _allIcons.append(ico)
                }
                
                return _allIcons
            } else {
                populateIcons()

                return self.allIcons
            }
        }
    }
    
    func iconForIndex(index: Int) -> Ico?{
        if allIcons.count > 0 && index < allIcons.count{
            return allIcons[index]
        }
        
        return nil
    }

    func iconsImageName(id : String) -> String?{
        let icoOpt: Ico? = self.iconById(id)
        if let ico = icoOpt{
            return ico.imagename
        }
        
        return nil
    }
    
    func iconById(id : String) -> Ico?{
        for ico in self.allIcons{
            if ico.id == id{
                return ico
            }
        }
        
        return nil
    }
    
    
    // - MARK: Tasks
    func fetchAllTasks(successBlock: (allTaskData: [SOTask], error: NSErrorPointer) -> Void) {
        let backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = persistentStoreCoordinator

        backgroundContext.performBlock{[weak self] in
            
            func fetchAllTasks() -> Bool{
                let fetchRequest = NSFetchRequest(entityName: "Task")
                var fetchError: NSError?
                let tasks = self!.managedObjectContext!.executeFetchRequest(fetchRequest, error: &fetchError) as! [Task]
                
                if  let error = fetchError{
                    assert(false, "Failed to execute the fetch request \(error.localizedDescription)")
                        
                    return false
                } else {
                    if tasks.count > 0 {
                        dispatch_async(dispatch_get_main_queue(), {
                            self!._allTasks.removeAll(keepCapacity: false)

                            for task in tasks{
                                var categorySelected: Bool = false
                                if let category = self?.categoryById(task.category){
                                    categorySelected = category.selected
                                }
                                
                                let icons = [task.ico1, task.ico2, task.ico3, task.ico4, task.ico5, task.ico6]
                                var iconsSelected: Bool = true
                                
                                for iconId in icons{
                                    let iconOpt: Ico? = self?.iconById(iconId)
                                    if let ico = iconOpt{
                                        iconsSelected = iconsSelected && ico.selected
                                    }
                                }
                                
                                if categorySelected && iconsSelected{
                                    let sotask = SOTask(task: task)
                                    self!._allTasks.append(sotask)
                                }
                                
                            }
                            var fetchError: NSError?
                            successBlock(allTaskData: self!._allTasks, error: &fetchError)
                            
                            if let error = fetchError{
                                if error.code > 0{
                                    assert(false, "Failed to execute the fetch request \(error.localizedDescription)")
                                }
                            }
                        })
                        
                        return true
                    }
                    else {
                        return false
                    }
                }
            }

            if !fetchAllTasks() {
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
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource(DatabaseName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
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
    
    private lazy var managedObjectContext: NSManagedObjectContext? = {
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
    
    func saveContext() {
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
    
    func deleteObject(objectForDeleting: NSManagedObject?)
    {
        if let moc = self.managedObjectContext {
            if let object = objectForDeleting{
                moc.deleteObject(object)
                self.saveContext()
            }
        }
    }
    
}
