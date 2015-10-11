//
//  SOLocalDataBase.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

let TaskEntityName = "Task"

public class SOLocalDataBase: SODataBaseProtocol {
    private let queue = dispatch_queue_create("localDataBaseRequestsQ", DISPATCH_QUEUE_CONCURRENT);
    private var nextDataBase: SODataBaseProtocol?
    private var coreData: SOCoreDataProtocol
    private var populateDataBase: SOPopulateLocalDataBase
    
    required public init(nextDataBase: SODataBaseProtocol?){
        self.nextDataBase = nextDataBase
        self.coreData = SOCoreDataBase(dataBaseName: "SwiftOrganizer")
        self.populateDataBase = SOPopulateLocalDataBase()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillTerminate:", name: UIApplicationWillTerminateNotification,  object: nil)
    }
    
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
    // TODO: - I tried to make generic for allCategories and the allIcons function but faced some principal problems
    // MARK: Categories
    public func allCategories(completionBlock: (resultBuffer: [SOCategory], error: NSError?) -> Void){
        var _allCategories: [SOCategory] = []
        var _needRecursiveCall: Bool = false
        
        dispatch_sync(self.queue, {() in
            let fetchRequest = NSFetchRequest(entityName: CategoryEntityName)

            
            /*
            // Example of filtering and sorting:
            
            let predicate = NSPredicate(format: "title='The first book'")
            let lengthSort = NSSortDescriptor(key: "length", ascending: true)
            let alphaSort = NSSortDescriptor(key: "text", ascending: false)
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [lengthSort, alphaSort]
            
            */
            
            
            let objects = (try! self.coreData.managedObjectContext!.executeFetchRequest(fetchRequest)) as! [TaskCategory]
            
            if objects.count > 0{
                objects.map({object in
                    let theObject = object as NSManagedObject
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
        })
        
        if _needRecursiveCall{
            return self.allCategories(completionBlock)
        }
        
        completionBlock(resultBuffer: _allCategories, error: nil)
    }
    
    // MARK: - Icons
    
    public func allIcons(completionBlock: (resultBuffer: [SOIco], error: NSError?) -> Void){
        var _allIcon: [SOIco] = []
        var _needRecursiveCall: Bool = false
        
        dispatch_sync(self.queue, {() in
            let fetchRequest = NSFetchRequest(entityName: IcoEntityName)
            
            let objects = (try! self.coreData.managedObjectContext!.executeFetchRequest(fetchRequest)) as! [TaskIco]
            
            if objects.count > 0{
                objects.map({object in
                    let theObject = object as NSManagedObject
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
        })
        
        if _needRecursiveCall{
            return self.allIcons(completionBlock)
        }
        
        completionBlock(resultBuffer: _allIcon, error: nil)
    }
    
    // MARK: - Tasks
    public func allTasks(completionBlock: (resultBuffer: [SOTask], error: NSError?) -> Void) {
        let currentUser: SOUser? = SOLocalUserManager.sharedInstance.currentUser
        
        if currentUser ==  nil{
            completionBlock(resultBuffer: [], error: nil)
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
                                    
                                    if let category = SOFetchingData.sharedInstance.categoryById(task.category){
                                        categorySelected = category.selected
                                    }
                                    
                                    let icons = [task.ico1, task.ico2, task.ico3, task.ico4, task.ico5, task.ico6]
                                    var iconsSelected: Bool = false
                                    
                                    for iconId in icons{
                                        if let ico = SOFetchingData.sharedInstance.iconById(iconId){
                                            iconsSelected = iconsSelected || ico.selected
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
        let category = task.category
        let date = task.date
        let taskIcons = [task.ico1, task.ico2, task.ico3, task.ico4, task.ico5, task.ico6]
        var _icons = [String](count: MaxIconsCount, repeatedValue: "")
        for i in 0..<MaxIconsCount{
            _icons[i] = taskIcons[i]
        }
        
        let newTask: SOTask = SOTask(object: task, userid: userid, title: title, category: category, date: date, icons: _icons)
        
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
            let predicate = NSPredicate(format: "recordid == %@", recordid)
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
}

// MARK: - Save Objects

extension SOLocalDataBase{
    
    public func saveTask(task: SOTask, completionBlock: (error: NSError?) -> Void){
        dispatch_sync(self.queue, {() in
            var userId: String = "777"
            if let curreentUser = SOLocalUserManager.sharedInstance.currentUser{
                userId = curreentUser.userid
            }
            task.userid = userId
            
            let taskObject: Task!
            
            if let object = task.databaseObject as? Task{
                taskObject = object
            }
            else{
                taskObject = self.coreData.newManagedObject(TaskEntityName) as! Task
                task.databaseObject = taskObject
            }
            taskObject.userid = task.userid
            taskObject.title = task.title
            taskObject.category = task.category
            let icons = task.icons
            taskObject.ico1 = icons[0]
            taskObject.ico2 = icons[1]
            taskObject.ico3 = icons[2]
            taskObject.ico4 = icons[3]
            taskObject.ico5 = icons[4]
            taskObject.ico6 = icons[5]
            if let date = task.date{
                taskObject.date = date
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
        })
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
