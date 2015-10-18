//
//  SOLocalDataBase.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

let TaskEntityName = "Task"
let TaskIconEntityName = "TaskIcon"
let LocalDataBaseName = "SwiftOrganizer"

public class SOLocalDataBase: NSObject, SODataBaseProtocol{
    private let queue = dispatch_queue_create("localDataBaseRequestsQ", DISPATCH_QUEUE_CONCURRENT);
    private var nextDataBase: SODataBaseProtocol?

    required public init(nextDataBase: SODataBaseProtocol?){
        self.nextDataBase = nextDataBase
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillTerminate:", name: UIApplicationWillTerminateNotification,  object: nil)
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
        let defaults = SOUserDefault.sharedDefaults()
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


// MARK: - Log In

extension SOLocalDataBase{
    public func currentUserHasLoggedIn() -> Bool{
        return AILogInManager.sharedInstance().isCurrentUserAlreadyLoggedIn()
    }
    
    public func userInfo() -> Dictionary<String, String>?{
        if let currentUser = SOLocalUserManager.sharedInstance.currentUser{
            let dict: Dictionary<String, String> = ["name": currentUser.name, "photo": currentUser.photo_prefix]
            return dict
        }
        return nil
    }
    
    public func logIn(viewController: UIViewController, completionBlock: (error: NSError?) -> Void){
        if self.currentUserHasLoggedIn(){
            completionBlock(error: nil)
        } else {
            AILogInManager.sharedInstance().logInViaFacebookWithViewControoler(viewController, completionBlock: {(loginState: AILoginState) in
                if loginState != OperationIsRanSuccessfully{
                    var dict = [String: AnyObject]()
                    dict[NSLocalizedDescriptionKey] = "Failed to Log In via Facebook".localized
                    dict[NSLocalizedFailureReasonErrorKey] = "Failed to Log In via Facebook".localized
                    let error2 = NSError(domain: DataBaseErrorDomain, code: 9999, userInfo: dict)
                    
                    completionBlock(error: error2)
                }
                completionBlock(error: nil)
            })
        }
    }
    
    public func logOut(viewController: UIViewController, completionBlock: (error: NSError?) -> Void){
        AILogInManager.sharedInstance().logOutAlertWithViewController(viewController,  completionBlock: {() in
            completionBlock(error: nil)
        })
    }
}

// MARK: -

extension SOLocalDataBase{

    public func allCategories(completionBlock: (resultBuffer: [SOCategory], error: NSError?) -> Void){
        var _allCategories: [SOCategory] = []
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
                    let theObject = object as! Category
                    let recordid = theObject.valueForKey(kFldRecordId) as! String
                    let selected = theObject.valueForKey(kFldSelected) as! Bool
                    let visible = theObject.valueForKey(kFldVisible) as! Bool
                    let name = theObject.valueForKey(kCategoryFldName) as! String
                    let category = SOCategory(object: objects, id: recordid, selected: selected, visible: visible, name: name)
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
    
    public func allIcons(completionBlock: (resultBuffer: [SOIco], error: NSError?) -> Void){
        var _allIcon: [SOIco] = []
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
                    let ico = SOIco(object: objects, id: recordid, selected: selected, visible: visible, name: name, imageName: imageName)
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
    public func allTasks(completionBlock: (resultBuffer: [SOTask], error: NSError?) -> Void) {
        let currentUser: SOUser? = SOLocalUserManager.sharedInstance.currentUser
        
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
                if let curreentUser = SOLocalUserManager.sharedInstance.currentUser{
                    userId = curreentUser.userid
                }
                
                let fetchRequest = NSFetchRequest(entityName: TaskEntityName)
                if userId != nil{
                    let predicate = NSPredicate(format: "userid == \(userId!)", "")
                    fetchRequest.predicate = predicate
                }
                let tasks = (try! self!.coreData.managedObjectContext!.executeFetchRequest(fetchRequest)) as! [Task]
                
                if tasks.count > 0 {
                    self!.prepareAllDependencies{(fetchError: NSError?) in
                        if let error = fetchError{
                            completionBlock(resultBuffer: [], error: error)
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                var _allTasks: [SOTask] = []
                                
                                for task: Task in tasks{
                                    var categorySelected: Bool = false
                                    
                                    if let category: Category = task.category{
                                        categorySelected = category.selected as! Bool
                                    }
                                    
                                    var iconsSelected: Bool = false
                                    
                                    if let icons = task.icons{
                                        let arr = icons.allObjects
                                        
                                        for anyObject: AnyObject in arr {
                                            let taskIcon = anyObject as! TaskIcon
                                            let ico = taskIcon.icon
                                            iconsSelected = ico.selected as! Bool
                                        }
                                    }
                                    
                                    if categorySelected && iconsSelected{
                                        let sotask = self!.newTask(task)
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
            dataSource.allCategories{(categories: [SOCategory], fetchError: NSError?) in
                if let error = fetchError{
                    completionBlock(error: error)
                }
            }
            });
        
        dispatch_group_async(taskGroup, serialQueue, {
            dataSource.allIcons{(resultBuffer: [SOIco], fetchError: NSError?) in
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
        //            dataSource.allCategories{(categories: [SOCategory], fetchError: NSError?) in
        //                if let error = fetchError{
        //                    completionBlock(error: error)
        //                }
        //            }
        //        })
        //        dispatch_async(serialQueue, { () in
        //            dataSource.allIcons{(resultBuffer: [SOIco], fetchError: NSError?) in
        //                if let error = fetchError{
        //                    completionBlock(error: error)
        //                } else {
        //                    // Here the sequebce is finishing
        //                    completionBlock(error: nil)
        //                }
        //            }
        //        })
        
    }
    
    private func newTask(task: Task) -> SOTask{
        let userid = task.userid
        let title = task.title
        var categoryId: String = ""
        if let category = task.category{
            categoryId = category.recordid!
        }
        let date = task.date
        var _icons = [String](count: MaxIconsCount, repeatedValue: "")

        if let icons = task.icons{
            let arr = icons.allObjects
            var i: Int = 0
            
            for anyObject: AnyObject in arr {
                let taskIcon = anyObject as! TaskIcon
                let ico = taskIcon.icon
                if let recordid = ico.recordid{
                    if i < MaxIconsCount{
                        _icons[i++] = recordid
                    }
                }
            }
        }
        let objectID: NSManagedObjectID = task.objectID
        let newTask = SOTask(object: objectID, userid: userid, title: title!, category: categoryId, date: date, icons: _icons)
        
        return newTask
    }
    
    public func getRecordIdForTask(task: SOTask?) -> String?{
        guard let theTtask = task, let object = theTtask.databaseObject as? Task else
        {
            return nil
        }
        let instanceURL: NSURL = object.objectID.URIRepresentation()
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

        if let curreentUser = SOLocalUserManager.sharedInstance.currentUser{
            userId = curreentUser.userid
        }
        return userId
    }
    
}

// MARK: - Save Objects

extension SOLocalDataBase{
    
    public func saveTask(task: SOTask, completionBlock: (error: NSError?) -> Void){
        guard let userId = currentUserId() else{
            completionBlock(error: nil)

            return
        }
        dispatch_sync(self.queue, {() in
            task.userid = userId
            
            let taskObject: Task!
            
            if let objectID = task.databaseObject as? NSManagedObjectID{
                taskObject = self.coreData.managedObjectContext!.objectWithID(objectID) as! Task
            }
            else{
                taskObject = self.coreData.newManagedObject(TaskEntityName) as! Task
                task.databaseObject = taskObject
            }
            taskObject.userid = task.userid
            taskObject.title = task.title
            if let category: Category = self.categoryWithId(task.category){
                taskObject.category = category
            }
            if let date = task.date{
                taskObject.date = date
            }

            if let currentIcons = taskObject?.mutableSetValueForKey("icons"){
                let arr = currentIcons.allObjects
                for anyObject: AnyObject in arr {
                    let taskIcon = anyObject as! TaskIcon
                    let taskIcons = taskIcon.icon.mutableSetValueForKey("taskicon")
                    for anyObject: AnyObject in taskIcons.allObjects {
                        let taskIcon = anyObject as! TaskIcon
                        self.coreData.deleteObject(taskIcon)
                    }
                    taskIcons.removeAllObjects()
                    self.coreData.deleteObject(taskIcon)
                }
                currentIcons.removeAllObjects()
            }

            let icons = task.icons
            for iconId: String in icons{
                if let icon: Icon = self.iconWithId(iconId){
                    let taskIcon  = self.coreData.newManagedObject(TaskIconEntityName) as! TaskIcon
                    taskIcon.task = taskObject
                    taskIcon.icon = icon
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
    
    public func removeTask(task: SOTask){
        dispatch_barrier_sync(self.queue, { () in
            let taskObject: Task? = task.databaseObject as? Task
            self.coreData.deleteObject(taskObject)
            self.coreData.saveContext()
        })
    }
    
}

// MARK: - Other functions

extension SOLocalDataBase{
    func iconWithId(iconId: String) -> Icon? {
        if iconId.isEmpty{
            return nil
        }
        
        let request = NSFetchRequest(entityName: "Icon")
        request.predicate = NSPredicate(format: "recordid == \"\(iconId)\"", "")
        request.sortDescriptors = []
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.coreData.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try controller.performFetch()

            if let objects = controller.fetchedObjects{
                if objects.count > 0{
                    return objects[0] as? Icon
                }
            }
        } catch let error as NSError {
            print("Failed to fetching Icon data \(error)")
        }
        
        return nil
    }
    
    func categoryWithId(categoryId: String) -> Category? {
        if categoryId.isEmpty{
            return nil
        }
        
        let request = NSFetchRequest(entityName: "Category")
        request.predicate = NSPredicate(format: "recordid == \"\(categoryId)\"", "")
        request.sortDescriptors = []
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.coreData.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try controller.performFetch()
            
            if let objects = controller.fetchedObjects{
                if objects.count > 0{
                    return objects[0] as? Category
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
        if let obj1: Task = object1 as? Task, let obj2: Task = object2 as? Task{
            return obj1 == obj2
        }
        
        return true
    }
    
}
