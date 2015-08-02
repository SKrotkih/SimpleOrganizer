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
let CategoryEntityName = "TaskCategory"
let IcoEntityName = "TaskIco"
let TaskEntityName = "Task"

public class SOLocalDataBase: SODataBaseProtocol {
    
    public class func sharedInstance() -> SODataBaseProtocol{
        struct SingletonWrapper {
            static let sharedInstance = SOLocalDataBase()
        }
        return SingletonWrapper.sharedInstance;
    }
    
    private init() {
    }

    private func fillNewObjectWithData<T: SOConcreteObjectsProtocol, T2: AnyObject>(newObject: T, managedObject: T2) -> T{
        newObject.initFromCoreDataObject(managedObject)
        
        return newObject
    }
    
    // - MARK: Categories
    public func allCategories(block: (resultBuffer: [SOCategory], error: NSError?) -> Void){
        var _allCategories: [SOCategory] = []
        
        let fetchRequest = NSFetchRequest(entityName: CategoryEntityName)
        
        var requestError: NSError?
        let categories = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: &requestError) as! [TaskCategory]
        
        if let error = requestError{
            block(resultBuffer: _allCategories, error: error)
        } else {
            if categories.count > 0{
                for category: TaskCategory in categories{
                    let categoryItem = self.fillNewObjectWithData(SOCategory(), managedObject: category)
                    _allCategories.append(categoryItem)
                }
                block(resultBuffer: _allCategories, error: nil)
            } else {
                populateCategories()
                
                return self.allCategories(block)
            }
        }
    }
    
    // - MARK: Icons
    public func allIcons(block: (resultBuffer: [SOIco], error: NSError?) -> Void){
        var _allIcon: [SOIco] = []
        
        let fetchRequest = NSFetchRequest(entityName: IcoEntityName)
        
        var requestError: NSError?
        let icons = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: &requestError) as! [TaskIco]
        
        if let error = requestError{
            block(resultBuffer: _allIcon, error: error)
        } else {
            if icons.count > 0{
                for ico: TaskIco in icons{
                    let icoItem = self.fillNewObjectWithData(SOIco(), managedObject: ico)
                    _allIcon.append(icoItem)
                }
                block(resultBuffer: _allIcon, error: nil)
            } else {
                populateIcons()
                
                return self.allIcons(block)
            }
        }
    }
    
    // - MARK: Tasks
    public func allTasks(block: (resultBuffer: [SOTask], error: NSError?) -> Void) {
        let backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        backgroundContext.performBlock{[weak self] in
            
            func fetchAllTasks() -> Bool{
                let fetchRequest = NSFetchRequest(entityName: TaskEntityName)
                var fetchError: NSError?
                let tasks = self!.managedObjectContext!.executeFetchRequest(fetchRequest, error: &fetchError) as! [Task]
                
                if  let error = fetchError{
                    assert(false, "Failed to execute the fetch request \(error.localizedDescription)")
                    
                    return false
                } else {
                    if tasks.count > 0 {
                        SODataFetching.sharedInstance.prepareAllSubTables{(fetchError: NSError?) in
                            if let error = fetchError{
                                block(resultBuffer: [], error: error)
                            } else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    var _allTasks: [SOTask] = []
                                    
                                    for task in tasks{
                                        var categorySelected: Bool = false
                                        if let category = SODataFetching.sharedInstance.categoryById(task.category){
                                            categorySelected = category.selected
                                        }
                                        
                                        let icons = [task.ico1, task.ico2, task.ico3, task.ico4, task.ico5, task.ico6]
                                        var iconsSelected: Bool = true
                                        
                                        for iconId in icons{
                                            let iconOpt: SOIco? = SODataFetching.sharedInstance.iconById(iconId)
                                            if let ico = iconOpt{
                                                iconsSelected = iconsSelected && ico.selected
                                            }
                                        }
                                        
                                        if categorySelected && iconsSelected{
                                            let sotask = self!.newTask(task)
                                            _allTasks.append(sotask)
                                        }
                                    }
                                    block(resultBuffer: _allTasks, error: nil)
                                })
                            }
                        }
                        
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
    
    private func newTask(task: Task) -> SOTask{
        var newTask: SOTask = SOTask()
        newTask.initFromCoreDataObject(task)
        
        return newTask
    }
    
    public func saveTask(task: SOTask, block: (error: NSError?) -> Void){
        let taskObject: Task? = task.databaseObject as? Task
        
        if let object = taskObject{
            task.copyToCoreDataObject(object)
        }
        else{
            let object = self.newTaskManagedObject()
            task.databaseObject = object
            task.copyToCoreDataObject(object)
        }
        self.saveContext()
        
        block(error: nil)
    }
    
    public func removeTask(task: SOTask){
        let taskObject: Task? = task.databaseObject as? Task
        self.deleteObject(taskObject)
    }
    
    public func recordIdForTask(task: SOTask?) -> String?{
        if let _task = task{
            if let object = _task.databaseObject as? Task{
                let instanceURL: NSURL = object.objectID.URIRepresentation()
                let classURL = instanceURL.URLByDeletingLastPathComponent
                let recordId = instanceURL.lastPathComponent
                
                return recordId
            }
        }
        
        return nil
    }
    
    // MARK: -
    // MARK: - Core Data stack
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource(DatabaseName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        
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
            if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options, error: &error) == nil {
                coordinator = nil
                self.reportAnyErrorWeGot(error)
            }
        } else {
            coordinator = nil
            var dict = [String: AnyObject]()
            let error: NSError? = NSError(domain: DataBaseErrorDomain, code: 9998, userInfo: dict)
            self.reportAnyErrorWeGot(error)
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

        if self.isiCloudEnabled(){
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
        
        return managedObjectContext
        }()

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.domenicosolazzo.swift.Reading_data_from_CoreData" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    // MARK: -
    // MARK: - Core Data Saving support
    
    public func saveFieldToObject(object: AnyObject?, fieldName: String, value: AnyObject, block: (error: NSError?) -> Void){
        let managedObject = object as? NSManagedObject
        
        if let object = managedObject{
            object.setValue(value, forKey: fieldName);
        }
        else{
            
        }
        
        self.saveContext()
        block(error: nil)
    }
    
    public func saveContext() {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges{
                if !moc.save(&error) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                } else {
                    moc.reset()
                }
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

    //- MARK: Helper methods
    //- MARK: Fill the local data base by predefined data

extension SOLocalDataBase{

    func newTaskManagedObject() -> Task!{
        let entityName = NSStringFromClass(Task.classForCoder())
        let task  = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: self.managedObjectContext!) as! Task
        
        return task
    }
    
    private func populateTasks(){
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
        let entityName = NSStringFromClass(TaskIco.classForCoder())
        
        for dict in icons{
            let ico = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: self.managedObjectContext!) as! TaskIco
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
        let entityName = NSStringFromClass(TaskCategory.classForCoder())
        
        for catagoryName in categories{
            let category = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: self.managedObjectContext!) as! TaskCategory
            let newCategoryId = "\(categoryId++)"
            category.id = newCategoryId
            category.name = catagoryName as String
            category.selected = true
        }
        
        saveContext()
    }
}

    //- MARK: Other local functions

extension SOLocalDataBase{
    public func areObjectsEqual(object1: AnyObject?, object2: AnyObject?) -> Bool{
        if let obj1: Task = object1 as? Task, let obj2: Task = object2 as? Task{
            return obj1 == obj2
        }
        
        return true
    }
    
    private func reportAnyErrorWeGot(error: NSError?){
        // Report any error we got.
        var dict = [String: AnyObject]()
        dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
        dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
        dict[NSUnderlyingErrorKey] = error
        let error2 = NSError(domain: DataBaseErrorDomain, code: 9999, userInfo: dict)
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog("Unresolved error \(error2), \(error2.userInfo)")
        abort()
    }

    func isiCloudEnabled() -> Bool{
        let defaults = SOUserDefault.sharedDefaults()
        let useiCloudOpt: Bool? = defaults.boolForKey(SOEnableiCloudForCoreDataKey)
        
        if let useiCloud = useiCloudOpt{
            return useiCloud
        }
        
        return false
    }
    
}

