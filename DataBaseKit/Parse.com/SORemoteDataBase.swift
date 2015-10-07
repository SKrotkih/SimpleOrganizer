//
//  SORemoteDataBase.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import Parse

let CategoryClassName = "Category"
let IcoClassName = "Ico"
let TaskClassName = "Task"

let kTaskFldTitle = "title"
let kTaskFldCategory = "category"
let kTaskFldIco1 = "ico1"
let kTaskFldIco2 = "ico2"
let kTaskFldIco3 = "ico3"
let kTaskFldIco4 = "ico4"
let kTaskFldIco5 = "ico5"
let kTaskFldIco6 = "ico6"
let kTaskFldDate = "date"

let kFldVisible = "visible"
let kFldSelected = "selected"
let kFldRecordId = "recordid"

let kCategoryFldName = "name"
let kIcoFldName = "name"
let kIcoFldImageName = "imagename"

public class SORemoteDataBase: SODataBaseProtocol {
    private let queue = dispatch_queue_create("remoteDataBaseRequestsQ", DISPATCH_QUEUE_CONCURRENT);
    private var nextDataBase: SODataBaseProtocol?
    let populateDataBase: SOPopulateRemoteDataBase
    
    required public init(nextDataBase: SODataBaseProtocol?){
        self.nextDataBase = nextDataBase
        populateDataBase = SOPopulateRemoteDataBase()
    }
    
    public func chainResponsibility(dataBaseIndex: DataBaseIndex) -> SODataBaseProtocol{
        if dataBaseIndex == .ParseComIndex{
            return self
        }
        return self.nextDataBase!.chainResponsibility(dataBaseIndex)
    }
    
    public func getObjectForRecordId(recordid: String, entityName: String) -> AnyObject?{
        return nil
    }
    
    public func getRecordIdForTask(task: SOTask?) -> String?{
        return nil
    }
}

// - MARK: -
// - MARK: Log In

extension SORemoteDataBase{

    public func currentUserHasLoggedIn() -> Bool{
        return SOParseComManager.currentUserHasLoggedIn()
    }
    
    public func logIn(viewController: UIViewController, completionBlock: (error: NSError?) -> Void){
        SOParseComManager.logIn(completionBlock)
    }
    
    public func logOut(viewController: UIViewController, completionBlock: (error: NSError?) -> Void){
        completionBlock(error: nil)
    }
}

    // - MARK: -
    // - MARK: Fetch Data

extension SORemoteDataBase{
    public func allCategories(completionBlock: (resultBuffer: [SOCategory], error: NSError?) -> Void){
        self.fetchAllDataWithClassName(CategoryClassName, completionBlock: {(resultBuffer: [AnyObject], error: NSError?) in
            let buffer = resultBuffer as! [SOCategory]
            completionBlock(resultBuffer: buffer, error: error)
        })
    }
    
    public func allIcons(completionBlock: (resultBuffer: [SOIco], error: NSError?) -> Void){
        self.fetchAllDataWithClassName(IcoClassName, completionBlock: {(resultBuffer: [AnyObject], error: NSError?) in
            let buffer: [SOIco] = resultBuffer as! [SOIco]
            completionBlock(resultBuffer: buffer, error: error)
        })
    }
    
    public func allTasks(completionBlock: (resultBuffer: [SOTask], error: NSError?) -> Void) {
        self.fetchAllDataWithClassName(TaskClassName, completionBlock: {(resultBuffer: [AnyObject], fetchError: NSError?) in
            if let error = fetchError{
                completionBlock(resultBuffer: [], error: error)
            }
            
            let tasks = resultBuffer as! [SOTask]
            
            if tasks.count > 0 {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    var _allTasks: [SOTask] = []
                    
                    for task in tasks{
                        var categorySelected: Bool = false
                        
                        if let category = SOFetchingData.sharedInstance.categoryById(task.category){
                            categorySelected = category.selected
                        }
                        
                        let icons = task.icons
                        var iconsSelected: Bool = false
                        
                        for iconId in icons{
                            let iconOpt: SOIco? = SOFetchingData.sharedInstance.iconById(iconId)
                            if let ico = iconOpt{
                                iconsSelected = iconsSelected || ico.selected
                            }
                        }
                        
                        if categorySelected && iconsSelected{
                            _allTasks.append(task)
                        }
                        
                    }
                    completionBlock(resultBuffer: _allTasks, error: nil)
                })
            }
            else {
                completionBlock(resultBuffer: [], error: nil)
            }
        })
    }
    
    private func fetchAllDataWithClassName(className: String, completionBlock: (resultBuffer: [AnyObject], error: NSError?) -> Void){
        let query = PFQuery(className: className)
        query.findObjectsInBackgroundWithBlock {(objects, fetchError) in
            var resultBuffer: [AnyObject] = []
            if let anError = fetchError {
                completionBlock(resultBuffer: resultBuffer, error: anError)
            } else {
                if let pfObjects: [PFObject] = objects{
                    if pfObjects.count > 0{
                        pfObjects.map({object in
                            resultBuffer.append(self.newInstanceFactory(object, className: className)!)
                        })
                        completionBlock(resultBuffer: resultBuffer, error: nil)
                    } else {
                        self.populateDataBase.populateDefaultData(className, completionBlock: {(populateError: NSError?) -> Void in
                            
                            if let anError = populateError{
                                completionBlock(resultBuffer: resultBuffer, error: anError)
                            } else {
                                self.fetchAllDataWithClassName(className, completionBlock: completionBlock)
                            }
                        })
                    }
                }
            }
        }
    }
    
    private func newInstanceFactory(object: PFObject, className: String) -> AnyObject?{
        var newInstance: SOConcreteObjectsProtocol
        
        switch className{
        case IcoClassName:
            newInstance = SOIco()
        case CategoryClassName:
            newInstance = SOCategory()
        case TaskClassName:
            newInstance = SOTask()
        default:
            return nil
        }
        
        newInstance.initWithParseObject(object)
        
        return newInstance
    }
}

    // MARK: -
    // MARK: - Save Data

extension SORemoteDataBase{
    
    public func saveTask(task: SOTask, completionBlock: (error: NSError?) -> Void){
        dispatch_sync(self.queue, {[weak self] in
            var object: PFObject? = task.databaseObject as? PFObject
            
            if let taskObject = object{
                task.copyToParseObject(taskObject)
            } else {
                object = PFObject(className: TaskClassName)
                task.databaseObject = object
                task.copyToParseObject(object!)
            }
            
            self!.saveObject(object!, completionBlock: {(error: NSError?) in
                completionBlock(error: error)
            })
            })
    }

    private func saveObject(object: PFObject, completionBlock: (error: NSError?) -> Void){
        object.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
            if (success) {
                completionBlock(error: nil)
            } else {
                completionBlock(error: error)
            }
        }
    }

    public func saveFieldValueToObject(dataBaseObject: AnyObject?, entityName: String, fldName: String, recordId: String?, value: AnyObject, completionBlock: (error: NSError?) -> Void){
        self.saveFieldToObject(dataBaseObject, fieldName: fldName, value: value, completionBlock: {(error: NSError?) in
            completionBlock(error: error)
        })
    }
    
    public func saveFieldToObject(object: AnyObject?, fieldName: String, value: AnyObject, completionBlock: (error: NSError?) -> Void){
        if let pfObject = object as? PFObject{
            pfObject[fieldName] = value
            self.saveObject(pfObject, completionBlock: {(error: NSError?) in
                completionBlock(error: error)
            })
        }
    }
    
}

    // - MARK: -
    // - MARK: Remove Data

extension SORemoteDataBase{
    
    public func removeTask(task: SOTask){
        dispatch_barrier_sync(self.queue, {[weak self] in
            if let taskObject: PFObject = task.databaseObject as? PFObject{
                self!.deleteObject(taskObject)
            }
            })
    }
    
    private func deleteObject(object: PFObject)
    {
        object.deleteInBackground()
    }
    
}

extension SORemoteDataBase{
    
    public func areObjectsEqual(object1: AnyObject?, object2: AnyObject?) -> Bool{
        if let obj1: PFObject = object1 as? PFObject, let obj2: PFObject = object2 as? PFObject{
            return obj1 == obj2
        }
        
        return true
    }
    
}
