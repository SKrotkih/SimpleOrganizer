//
//  SORemoteDataBase.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import Parse
import ParseUI

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

public class SORemoteDataBase: NSObject, SODataBaseProtocol {
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
    
    public func getRecordIdForTask(task: Task?) -> String?{
        return nil
    }
}

    // - MARK: -
    // - MARK: Fetch Data

extension SORemoteDataBase{
    public func allCategories(completionBlock: (resultBuffer: [TaskCategory], error: NSError?) -> Void){
        self.fetchAllDataWithClassName(CategoryClassName, completionBlock: {(resultBuffer: [AnyObject], error: NSError?) in
            let buffer = resultBuffer as! [TaskCategory]
            completionBlock(resultBuffer: buffer, error: error)
        })
    }
    
    public func allIcons(completionBlock: (resultBuffer: [TaskIco], error: NSError?) -> Void){
        self.fetchAllDataWithClassName(IcoClassName, completionBlock: {(resultBuffer: [AnyObject], error: NSError?) in
            let buffer: [TaskIco] = resultBuffer as! [TaskIco]
            completionBlock(resultBuffer: buffer, error: error)
        })
    }
    
    public func allTasks(completionBlock: (resultBuffer: [Task], error: NSError?) -> Void) {

        if PFUser.currentUser() == nil{
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Data doesn't accessible\nPlease log in to continue".localized
            let error: NSError? = NSError(domain: DataBaseErrorDomain, code: 9998, userInfo: dict)
            completionBlock(resultBuffer: [], error: error)
            
            return
        }
        
        self.fetchAllDataWithClassName(TaskClassName, completionBlock: {(resultBuffer: [AnyObject], fetchError: NSError?) in
            if let error = fetchError{
                completionBlock(resultBuffer: [], error: error)
            }
            
            let tasks = resultBuffer as! [Task]
            
            if tasks.count > 0 {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    var _allTasks: [Task] = []
                    
                    for task in tasks{
                        var categorySelected: Bool = false
                        
                        if let category = SOFetchingData.sharedInstance.categoryById(task.category){
                            categorySelected = category.selected
                        }
                        
                        let icons = task.icons
                        var iconsSelected: Bool = false
                        
                        for iconId in icons{
                            let iconOpt: TaskIco? = SOFetchingData.sharedInstance.iconById(iconId)
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
        if PFUser.currentUser() == nil{
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Data doesn't accessible\nPlease log in to continue".localized
            let error: NSError? = NSError(domain: DataBaseErrorDomain, code: 9998, userInfo: dict)
            completionBlock(resultBuffer: [], error: error)
            
            return
        }
        
        let query = PFQuery(className: className)
        query.findObjectsInBackgroundWithBlock {(objects, fetchError) in
            var resultBuffer: [AnyObject] = []
            if let anError = fetchError {
                completionBlock(resultBuffer: resultBuffer, error: anError)
            } else {
                if let pfObjects: [PFObject] = objects{
                    if pfObjects.count > 0{
                        let _ = pfObjects.map({object in
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
        var newInstance: AnyObject?
        
        switch className{
        case IcoClassName:
            let recordid = object[kFldRecordId] as! String
            let selected = object[kFldSelected] as! Bool
            let visible = object[kFldVisible] as! Bool
            let name = object[kIcoFldName] as! String
            let imageName = object[kIcoFldImageName] as! String
            newInstance = TaskIco(object: object, id: recordid, selected: selected, visible: visible, name: name, imageName: imageName)
        case CategoryClassName:
            let recordid = object[kFldRecordId] as! String
            let selected = object[kFldSelected] as! Bool
            let visible = object[kFldVisible] as! Bool
            let name = object[kCategoryFldName] as! String
            newInstance = TaskCategory(object: object, id: recordid, selected: selected, visible: visible, name: name)
        case TaskClassName:
            let title = object[kTaskFldTitle] as! String
            let category = object[kTaskFldCategory] as! String
            let date = object[kTaskFldDate] as! NSDate?
            var icons: [String] = []
            icons[0] = object[kTaskFldIco1] as! String
            icons[1] = object[kTaskFldIco2] as! String
            icons[2] = object[kTaskFldIco3] as! String
            icons[3] = object[kTaskFldIco4] as! String
            icons[4] = object[kTaskFldIco5] as! String
            icons[5] = object[kTaskFldIco6] as! String
            newInstance = Task(object: object, userid: nil, title: title, category: category, date: date, icons: icons)
        default:
            break
        }
        
        return newInstance
    }
}

    // MARK: -
    // MARK: - Save Data

extension SORemoteDataBase{
    
    public func taskForObjectID(objectID: AnyObject) -> Task?{
        if let taskObject: PFObject  = objectID as? PFObject{
            let task = newInstanceFactory(taskObject, className: TaskClassName) as! Task
            return task
        }
        return nil
    }
    
    public func saveTask(task: Task, completionBlock: (error: NSError?) -> Void){
        dispatch_sync(self.queue, {[weak self] in
            var object: PFObject!
            
            if let taskObject = task.databaseObject as? PFObject{
                object = taskObject
            } else {
                object = PFObject(className: TaskClassName)
                task.databaseObject = object
            }

            object[kTaskFldTitle] = task.title
            object[kTaskFldCategory] = task.category
            object[kTaskFldDate] = task.date
            let icons = task.icons
            object[kTaskFldIco1] = icons[0]
            object[kTaskFldIco2] = icons[1]
            object[kTaskFldIco3] = icons[2]
            object[kTaskFldIco4] = icons[3]
            object[kTaskFldIco5] = icons[4]
            object[kTaskFldIco6] = icons[5]
            
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
    
    public func removeTask(taskID: AnyObject){
        dispatch_barrier_sync(self.queue, {[weak self] in
            if let taskObject: PFObject = taskID as? PFObject{
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
