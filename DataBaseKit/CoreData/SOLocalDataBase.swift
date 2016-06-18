//
//  SOLocalDataBase.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

let TaskEntityName = "ManagedTask"
let TaskIconEntityName = "ManagedTaskIcon"
let LocalDataBaseName = "SwiftOrganizer"

public class SOLocalDataBase: NSObject, SODataBaseProtocol{
    private let queue = dispatch_queue_create("localDataBaseRequestsQ", DISPATCH_QUEUE_CONCURRENT);
    private var nextDataBase: SODataBaseProtocol?

    required public init(nextDataBase: SODataBaseProtocol?){
        self.nextDataBase = nextDataBase
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillTerminate(_:)), name: UIApplicationWillTerminateNotification,  object: nil)
    }
    
    lazy var populateDataBase: SOPopulateLocalDataBase = {
        return SOPopulateLocalDataBase(localDataBase: self)
    }()
    
    lazy var coreData: SOCoreDataProtocol = {
        var options: Dictionary<String, AnyObject> = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true
        ]
        let iCloudEnabled = self.isiCloudEnabled()
        if iCloudEnabled{
            options[NSPersistentStoreUbiquitousContentNameKey]  = "Store"
        }
        let coreData = SOCoreDataBase(dataBaseName: LocalDataBaseName, options: nil, iCloudEnabled: iCloudEnabled)

        return coreData
    }()
    
    
    public func chainResponsibility(dataBaseIndex: DataBaseIndex) -> SODataBaseProtocol{
        if dataBaseIndex == .CoreDataIndex{
            return self
        }
        return self.nextDataBase!.chainResponsibility(dataBaseIndex)
    }
    
    func applicationWillTerminate(notification: NSNotification){
        self.coreData.saveContext()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    private func isiCloudEnabled() -> Bool{
        let defaults = DefaultsUser.sharedDefaults()
        let useiCloudOpt: Bool? = defaults.boolForKey(DefaultsDataKeys.SOEnableiCloudForCoreDataKey)
        
        if let useiCloud = useiCloudOpt{
            return useiCloud
        }
        
        return false
    }
    
    lazy var categoriesController: NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: CategoryEntityName)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.coreData.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "categories")
        fetchedResultsController.delegate = self
        return fetchedResultsController
        }()

    
    lazy var iconsController: NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: IcoEntityName)
        request.sortDescriptors = [NSSortDescriptor(key: "recordid", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.coreData.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "icons")
        fetchedResultsController.delegate = self
        return fetchedResultsController
        }()
}

// MARK: - NSFetchedResultsControllerDelegate

extension SOLocalDataBase: NSFetchedResultsControllerDelegate {

    public func controllerWillChangeContent(controller: NSFetchedResultsController) {
    }

    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {

        /*
        let indexPathsFromOptionals: (NSIndexPath?) -> [NSIndexPath] = { indexPath in
            if let indexPath = indexPath {
                return [indexPath]
            }
            return []
        }
        
        switch type
        {
        case .Insert:
            tableView.insertRowsAtIndexPaths(indexPathsFromOptionals(newIndexPath), withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths(indexPathsFromOptionals(indexPath), withRowAnimation: .Automatic)
        default:
            break
        }
        */
        
    }
}

extension SOLocalDataBase{

    public func allCategories(completionBlock: (resultBuffer: [TaskCategory], error: NSError?) -> Void){
        var _allCategories: [TaskCategory] = []
        var _needRecursiveCall: Bool = false
        
        do {
            try categoriesController.performFetch()
        } catch let error as NSError {
            print("Failed to fetching category data \(error)")
        }
        
        if let objects = categoriesController.fetchedObjects
        {
            if objects.count > 0{
                let _ = objects.map({object in
                    let managedCategory = object as! ManagedCategory
                    let recordid = managedCategory.valueForKey(kFldRecordId) as! String
                    let selected = managedCategory.valueForKey(kFldSelected) as! Bool
                    let visible = managedCategory.valueForKey(kFldVisible) as! Bool
                    let name = managedCategory.valueForKey(kCategoryFldName) as! String
                    let category = TaskCategory(object: managedCategory, id: recordid, selected: selected, visible: visible, name: name)
                    _allCategories.append(category)
                })
            } else {
                self.populateDataBase.populateCategories()
                _needRecursiveCall = true
            }
        }
        
        if _needRecursiveCall{
            return self.allCategories(completionBlock)
        }
        
        completionBlock(resultBuffer: _allCategories, error: nil)
    }
    
    // MARK: - Icons
    
    public func allIcons(completionBlock: (resultBuffer: [TaskIco], error: NSError?) -> Void){
        var _allIcon: [TaskIco] = []
        var _needRecursiveCall: Bool = false
        
        do {
            try iconsController.performFetch()
        } catch let error as NSError {
            print("Error fetching category data \(error)")
        }
        
        if let objects = iconsController.fetchedObjects{
            if objects.count > 0{
                let _ = objects.map({object in
                    let theObject = object as! NSManagedObject
                    let recordid = theObject.valueForKey(kFldRecordId) as! String
                    let selected = theObject.valueForKey(kFldSelected) as! Bool
                    let visible = theObject.valueForKey(kFldVisible) as! Bool
                    let name = theObject.valueForKey(kIcoFldName) as! String
                    let imageName = theObject.valueForKey(kIcoFldImageName) as! String
                    let ico = TaskIco(object: theObject, id: recordid, selected: selected, visible: visible, name: name, imageName: imageName)
                    _allIcon.append(ico)
                })
            } else {
                self.populateDataBase.populateIcons()
                
                _needRecursiveCall = true
            }
        }
        
        if _needRecursiveCall{
            return self.allIcons(completionBlock)
        }
        
        completionBlock(resultBuffer: _allIcon, error: nil)
    }
    
    // MARK: - Tasks
    public func allTasks(completionBlock: (resultBuffer: [Task], error: NSError?) -> Void) {
        let currentUser: User? = UsersWorker.sharedInstance.currentUser
        
        if currentUser ==  nil{
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Data doesn't accessible\nPlease log in to continue".localized
            let error: NSError? = NSError(domain: DataBaseErrorDomain, code: 9998, userInfo: dict)
            completionBlock(resultBuffer: [], error: error)

            return
        }

        let backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = self.coreData.persistentStoreCoordinator
        
        backgroundContext.performBlock{[weak self] in
            
            func fetchAllTasks() -> Bool{
                var userId: String?
                if let curreentUser = UsersWorker.sharedInstance.currentUser{
                    userId = curreentUser.userid
                }
                
                let fetchRequest = NSFetchRequest(entityName: TaskEntityName)
                if userId != nil{
                    let predicate = NSPredicate(format: "userid == \(userId!)", "")
                    fetchRequest.predicate = predicate
                }
                let managedTasks = (try! self!.coreData.managedObjectContext!.executeFetchRequest(fetchRequest)) as! [ManagedTask]
                
                if managedTasks.count > 0 {
                    self!.prepareAllDependencies{(fetchError: NSError?) in
                        if let error = fetchError{
                            completionBlock(resultBuffer: [], error: error)
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                var _allTasks: [Task] = []
                                
                                for managedTask: ManagedTask in managedTasks{
                                    var categorySelected: Bool = false
                                    
                                    if let managedCategory: ManagedCategory = managedTask.category{
                                        categorySelected = managedCategory.selected as! Bool
                                    }
                                    
                                    var iconsSelected: Bool = false
                                    
                                    if let icons = managedTask.icons{
                                        let arr = icons.allObjects
                                        
                                        for anyObject: AnyObject in arr {
                                            let managedTaskIcon = anyObject as! ManagedTaskIcon
                                            let ico = managedTaskIcon.icon
                                            iconsSelected = ico.selected as! Bool
                                        }
                                    }
                                    
                                    if categorySelected && iconsSelected{
                                        let sotask = self!.newTask(managedTask)
                                        _allTasks.append(sotask)
                                    }
                                }
                                completionBlock(resultBuffer: _allTasks, error: nil)
                            })
                        }
                    }
                    
                    return true
                }
                else {
                    return false
                }
            }
            
            if !fetchAllTasks() {
                self!.populateDataBase.populateTasks()
                
                fetchAllTasks()
            }
        }
    }
    
    private func prepareAllDependencies(completionBlock: (error: NSError?) -> Void) {
        let dataSource = SOFetchingData.sharedInstance
        let serialQueue = dispatch_queue_create("serialQuieue", DISPATCH_QUEUE_SERIAL)
        
        // MARK: Grouping Task Together
        
        let taskGroup = dispatch_group_create()
        
        dispatch_group_async(taskGroup, serialQueue, {
            dataSource.allCategories{(categories: [TaskCategory], fetchError: NSError?) in
                if let error = fetchError{
                    completionBlock(error: error)
                }
            }
            });
        
        dispatch_group_async(taskGroup, serialQueue, {
            dataSource.allIcons{(resultBuffer: [TaskIco], fetchError: NSError?) in
                if let error = fetchError{
                    completionBlock(error: error)
                }
            }
            });
        
        dispatch_group_notify(taskGroup, serialQueue, {
            // Here the sequebce is finishing
            completionBlock(error: nil)
            });
        
        // MARK: Serial sequence: after fetching Categories are starting Icons fetching
        
        //        dispatch_async(serialQueue, { () in
        //            dataSource.allCategories{(categories: [TaskCategory], fetchError: NSError?) in
        //                if let error = fetchError{
        //                    completionBlock(error: error)
        //                }
        //            }
        //        })
        //        dispatch_async(serialQueue, { () in
        //            dataSource.allIcons{(resultBuffer: [TaskIco], fetchError: NSError?) in
        //                if let error = fetchError{
        //                    completionBlock(error: error)
        //                } else {
        //                    // Here the sequebce is finishing
        //                    completionBlock(error: nil)
        //                }
        //            }
        //        })
        
    }
    
    private func newTask(managedTask: ManagedTask) -> Task{
        let userid = managedTask.userid
        let title = managedTask.title
        var categoryId: String = ""
        if let category = managedTask.category{
            categoryId = category.recordid!
        }
        let date = managedTask.date
        var _icons: [String] = []

        if let icons = managedTask.icons{
            let arr = icons.allObjects
            
            for anyObject: AnyObject in arr {
                let managedTaskIcon = anyObject as! ManagedTaskIcon
                let ico = managedTaskIcon.icon
                if let recordid = ico.recordid{
                    _icons.append(recordid)
                }
            }
        }
        let objectID: NSManagedObjectID = managedTask.objectID
        let newTask = Task(object: objectID, userid: userid, title: title!, category: categoryId, date: date, icons: _icons)
        
        return newTask
    }
    
    public func getRecordIdForTask(task: Task?) -> String?{
        guard let theTtask = task, let managedTask = theTtask.databaseObject as? ManagedTask else
        {
            return nil
        }
        let instanceURL: NSURL = managedTask.objectID.URIRepresentation()
        let recordId = instanceURL.lastPathComponent
        
        return recordId
    }
    
    public func getObjectForRecordId(recordid: String, entityName: String) -> AnyObject?{
        var databaseObject: AnyObject? = nil
        
        dispatch_sync(self.queue, {() in
            let fetchRequest = NSFetchRequest(entityName: entityName)
            let predicate = NSPredicate(format: "recordid == \"%@\"", recordid)
            fetchRequest.predicate = predicate
            var requestError: NSError?
            let fetchedData: [AnyObject]?
            do {
                fetchedData = try self.coreData.managedObjectContext!.executeFetchRequest(fetchRequest)
            } catch let error as NSError {
                requestError = error
                fetchedData = nil
            } catch {
                fatalError()
            }
            
            if let error = requestError{
                print("\(error.localizedDescription)")
            } else if let theFetchedData = fetchedData as [AnyObject]?{
                if theFetchedData.count > 0{
                    databaseObject = theFetchedData[0]
                }
            }
        })
        
        return databaseObject
    }
    
    func currentUserId() -> String?{
        var userId: String?

        if let curreentUser = UsersWorker.sharedInstance.currentUser{
            userId = curreentUser.userid
        }
        return userId
    }
    
}

// MARK: - Save Objects

extension SOLocalDataBase{

    public func taskForObjectID(objectID: AnyObject) -> Task?{
        if let objectID = objectID as? NSManagedObjectID{
            let managedTask = self.coreData.managedObjectContext!.objectWithID(objectID) as! ManagedTask
            let task = self.newTask(managedTask)
            return task
        }
        return nil
    }
    
    public func saveTask(task: Task, completionBlock: (error: NSError?) -> Void){
        guard let userId = currentUserId() else{
            completionBlock(error: nil)

            return
        }
        dispatch_sync(self.queue, {() in
            task.userid = userId
            
            let managedTask: ManagedTask!
            
            if let objectID = task.databaseObject as? NSManagedObjectID{
                managedTask = self.coreData.managedObjectContext!.objectWithID(objectID) as! ManagedTask
            }
            else{
                managedTask = self.coreData.newManagedObject(TaskEntityName) as! ManagedTask
                task.databaseObject = managedTask
            }
            managedTask.userid = task.userid
            managedTask.title = task.title
            if let managedCategory: ManagedCategory = self.categoryWithId(task.category){
                managedTask.category = managedCategory
            }
            if let date = task.date{
                managedTask.date = date
            }

            if let currentIcons = managedTask?.mutableSetValueForKey("icons"){
                let arr = currentIcons.allObjects
                for anyObject: AnyObject in arr {
                    let managedTaskIcon = anyObject as! ManagedTaskIcon
                    let taskIcons = managedTaskIcon.icon.mutableSetValueForKey("taskicon")
                    for anyObject: AnyObject in taskIcons.allObjects {
                        let taskIcon = anyObject as! ManagedTaskIcon
                        self.coreData.deleteObject(taskIcon)
                    }
                    taskIcons.removeAllObjects()
                    self.coreData.deleteObject(managedTaskIcon)
                }
                currentIcons.removeAllObjects()
            }

            let icons = task.icons
            for iconId: String in icons{
                if let managedIcon: ManagedIcon = self.iconWithId(iconId){
                    let managedTaskIcon  = self.coreData.newManagedObject(TaskIconEntityName) as! ManagedTaskIcon
                    managedTaskIcon.task = managedTask
                    managedTaskIcon.icon = managedIcon
                }
            }
            self.coreData.saveContext()
        })
        
        completionBlock(error: nil)
    }
    
    public func saveFieldToObject(object: AnyObject?, fieldName: String, value: AnyObject, completionBlock: (error: NSError?) -> Void){
        let managedObject = object as? NSManagedObject
        
        if let object = managedObject{
            dispatch_async(dispatch_get_main_queue(), {[weak self] in
                let tryCatchException = KVOTryCatchException()
                //object.setValue(value, forKey: fieldName);
                if  let error: NSError = tryCatchException.trySetKeyValueForObject(object, forKeyPath: fieldName, value: value){
                    completionBlock(error: error)
                }
                else{
                    self!.coreData.saveContext()
                    completionBlock(error: nil)
                }
                })
        }
        else{
            let dict = [String: AnyObject]()
            let error: NSError? = NSError(domain: DataBaseErrorDomain, code: 9998, userInfo: dict)
            self.coreData.reportAnyErrorWeGot(error)
        }
    }
    
    public func saveFieldValueToObject(dataBaseObject: AnyObject?, entityName: String, fldName: String, recordId: String?, value: AnyObject, completionBlock: (error: NSError?) -> Void){
        var object: AnyObject? = dataBaseObject
        
        if let theRecordId = recordId{
            let dBaseObject: AnyObject? = self.getObjectForRecordId(theRecordId, entityName: entityName)
            
            if dBaseObject != nil{
                object = dBaseObject
            }
        }
        
        self.saveFieldToObject(object, fieldName: fldName, value: value, completionBlock: {(error: NSError?) in
            completionBlock(error: error)
        })
    }
}

// MARK: - Delete Objects

extension SOLocalDataBase{
    
    public func removeTask(taskID: AnyObject){
        dispatch_barrier_sync(self.queue, { () in
            let managedObjectID: NSManagedObjectID = taskID as! NSManagedObjectID
            do {
                let managedTask: NSManagedObject = try self.coreData.managedObjectContext!.existingObjectWithID(managedObjectID)
                    self.coreData.deleteObject(managedTask)
                    self.coreData.saveContext()
            } catch{
                var dict = [String: AnyObject]()
                dict[NSLocalizedDescriptionKey] = "Can't delete object!".localized
                let error: NSError? = NSError(domain: DataBaseErrorDomain, code: 9998, userInfo: dict)
                print(error?.localizedDescription)
            }
        })
    }
    
}

// MARK: - Other functions

extension SOLocalDataBase{
    func iconWithId(iconId: String) -> ManagedIcon? {
        if iconId.isEmpty{
            return nil
        }
        
        let request = NSFetchRequest(entityName: "ManagedIcon")
        request.predicate = NSPredicate(format: "recordid == \"\(iconId)\"", "")
        request.sortDescriptors = []
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.coreData.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try controller.performFetch()

            if let objects = controller.fetchedObjects{
                if objects.count > 0{
                    return objects[0] as? ManagedIcon
                }
            }
        } catch let error as NSError {
            print("Failed to fetching Icon data \(error)")
        }
        
        return nil
    }
    
    func categoryWithId(categoryId: String) -> ManagedCategory? {
        if categoryId.isEmpty{
            return nil
        }
        
        let request = NSFetchRequest(entityName: "ManagedCategory")
        request.predicate = NSPredicate(format: "recordid == \"\(categoryId)\"", "")
        request.sortDescriptors = []
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.coreData.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try controller.performFetch()
            
            if let objects = controller.fetchedObjects{
                if objects.count > 0{
                    return objects[0] as? ManagedCategory
                }
            }
        } catch let error as NSError {
            print("Failed to fetching Icon data \(error)")
        }
        
        return nil
    }
    
}

// MARK: - Other functions

extension SOLocalDataBase{
    public func areObjectsEqual(object1: AnyObject?, object2: AnyObject?) -> Bool{
        if let managedTask1: ManagedTask = object1 as? ManagedTask, let managedTask2: ManagedTask = object2 as? ManagedTask{
            return managedTask1 == managedTask2
        }
        
        return true
    }
    
}
