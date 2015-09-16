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
        self.coreData = SOCoreDataBase()
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

extension SOLocalDataBase{

    private func fillNewObjectWithData<T: SOConcreteObjectsProtocol, T2: AnyObject>(newObject: T, managedObject: T2) -> T{
        newObject.initWithCoreDataObject(managedObject)
        
        return newObject
    }
    
    // TODO: - I tried to make generic for allCategories and the allIcons function but faced some principal problems
    // MARK: Categories
    public func allCategories(completionBlock: (resultBuffer: [SOCategory], error: NSError?) -> Void){
        var _allCategories: [SOCategory] = []
        var _error: NSError?
        var _needRecursiveCall: Bool = false
        
        dispatch_sync(self.queue, {() in
            let fetchRequest = NSFetchRequest(entityName: CategoryEntityName)
            
            var fetchError: NSError?
            let objects = self.coreData.managedObjectContext!.executeFetchRequest(fetchRequest, error: &fetchError) as! [TaskCategory]
            
            if let error = fetchError{
                _error = error
            } else {
                if objects.count > 0{
                    objects.map({object in
                        _allCategories.append(self.fillNewObjectWithData(SOCategory(), managedObject: object))
                    })
                } else {
                    self.populateDataBase.populateCategories()
                    _needRecursiveCall = true
                }
            }
        })
        
        if _needRecursiveCall{
            return self.allCategories(completionBlock)
        }
        
        if _error == nil{
            completionBlock(resultBuffer: _allCategories, error: nil)
        } else {
            completionBlock(resultBuffer: [], error: _error)
        }
    }
    
    // MARK: - Icons
    
    public func allIcons(completionBlock: (resultBuffer: [SOIco], error: NSError?) -> Void){
        var _allIcon: [SOIco] = []
        var _error: NSError?
        var _needRecursiveCall: Bool = false
        
        dispatch_sync(self.queue, {() in
            let fetchRequest = NSFetchRequest(entityName: IcoEntityName)
            
            var fetchError: NSError?
            let objects = self.coreData.managedObjectContext!.executeFetchRequest(fetchRequest, error: &fetchError) as! [TaskIco]
            
            if let error = fetchError{
                _error = error
            } else {
                if objects.count > 0{
                    objects.map({object in
                        _allIcon.append(self.fillNewObjectWithData(SOIco(), managedObject: object))
                    })
                } else {
                    self.populateDataBase.populateIcons()
                    
                    _needRecursiveCall = true
                }
            }
        })
        
        if _needRecursiveCall{
            return self.allIcons(completionBlock)
        }
        
        if _error == nil{
            completionBlock(resultBuffer: _allIcon, error: nil)
        } else {
            completionBlock(resultBuffer: [], error: _error)
        }
    }
    
    // MARK: - Tasks
    public func allTasks(completionBlock: (resultBuffer: [SOTask], error: NSError?) -> Void) {
        let backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = self.coreData.persistentStoreCoordinator
        
        backgroundContext.performBlock{[weak self] in
            
            func fetchAllTasks() -> Bool{
                let fetchRequest = NSFetchRequest(entityName: TaskEntityName)
                var fetchError: NSError?
                let tasks = self!.coreData.managedObjectContext!.executeFetchRequest(fetchRequest, error: &fetchError) as! [Task]
                
                if  let error = fetchError{
                    assert(false, "Failed to execute the fetch request \(error.localizedDescription)")
                    
                    return false
                } else {
                    if tasks.count > 0 {
                        self!.prepareAllSubTables{(fetchError: NSError?) in
                            if let error = fetchError{
                                completionBlock(resultBuffer: [], error: error)
                            } else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    var _allTasks: [SOTask] = []
                                    
                                    for task: Task in tasks{
                                        var categorySelected: Bool = false
                                        
                                        if let category = SODataSource.sharedInstance.categoryById(task.category){
                                            categorySelected = category.selected
                                        }
                                        
                                        let icons = [task.ico1, task.ico2, task.ico3, task.ico4, task.ico5, task.ico6]
                                        var iconsSelected: Bool = false
                                        
                                        for iconId in icons{
                                            let iconOpt: SOIco? = SODataSource.sharedInstance.iconById(iconId)
                                            if let ico = iconOpt{
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
            }
            
            if !fetchAllTasks() {
                self!.populateDataBase.populateTasks()
                
                fetchAllTasks()
            }
        }
    }

    private func prepareAllSubTables(completionBlock: (error: NSError?) -> Void) {
        let dataSource = SODataSource.sharedInstance
        
        dataSource.allCategories{(categories: [SOCategory], fetchError: NSError?) in
            if let error = fetchError{
                completionBlock(error: error)
            } else {
                dataSource.allIcons{(resultBuffer: [SOIco], fetchError: NSError?) in
                    if let error = fetchError{
                        completionBlock(error: error)
                    } else {
                        completionBlock(error: nil)
                    }
                }
            }
        }
    }
    
    private func newTask(task: Task) -> SOTask{
        var newTask: SOTask = SOTask()
        newTask.initWithCoreDataObject(task)
        
        return newTask
    }
    
    public func getRecordIdForTask(task: SOTask?) -> String?{
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
    
    public func getObjectForRecordId(recordid: String, entityName: String) -> AnyObject?{
        var databaseObject: AnyObject? = nil
        
        dispatch_sync(self.queue, {() in
            let fetchRequest = NSFetchRequest(entityName: entityName)
            let predicate = NSPredicate(format: "recordid == %@", recordid)
            fetchRequest.predicate = predicate
            var requestError: NSError?
            let _class: AnyClass = NSClassFromString(entityName)
            let fetchedData = self.coreData.managedObjectContext!.executeFetchRequest(fetchRequest, error: &requestError)
            
            if let error = requestError{
                println("\(error.localizedDescription)")
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
            let taskObject: Task? = task.databaseObject as? Task
            
            if let object = taskObject{
                task.copyToCoreDataObject(object)
            }
            else{
                let object = self.coreData.newManagedObject("Task") as! Task
                task.databaseObject = object
                task.copyToCoreDataObject(object)
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
            var dict = [String: AnyObject]()
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
