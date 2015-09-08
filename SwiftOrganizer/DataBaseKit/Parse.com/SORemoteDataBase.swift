//
//  SORemoteDataBase.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

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
    private var currentCategoryIndex = 0
    private var currentIcoIndex = 0
    private var currentTaskIndex = 0
    var nextDataBase: SODataBaseProtocol?
    
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
    // - MARK: Fetch Data

extension SORemoteDataBase{
    public func allCategories(block: (resultBuffer: [SOCategory], error: NSError?) -> Void){
        self.fetchAllDataWithClassName(CategoryClassName, block: {(resultBuffer: [AnyObject], error: NSError?) in
            let buffer = resultBuffer as! [SOCategory]
            block(resultBuffer: buffer, error: error)
        })
    }
    
    public func allIcons(block: (resultBuffer: [SOIco], error: NSError?) -> Void){
        self.fetchAllDataWithClassName(IcoClassName, block: {(resultBuffer: [AnyObject], error: NSError?) in
            let buffer: [SOIco] = resultBuffer as! [SOIco]
            block(resultBuffer: buffer, error: error)
        })
    }
    
    public func allTasks(block: (resultBuffer: [SOTask], error: NSError?) -> Void) {
        self.fetchAllDataWithClassName(TaskClassName, block: {(resultBuffer: [AnyObject], fetchError: NSError?) in
            if let error = fetchError{
                block(resultBuffer: [], error: error)
            }
            
            let tasks = resultBuffer as! [SOTask]
            
            if tasks.count > 0 {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    var _allTasks: [SOTask] = []
                    
                    for task in tasks{
                        var categorySelected: Bool = false
                        
                        if let category = SODataFetching.sharedInstance.categoryById(task.category){
                            categorySelected = category.selected
                        }
                        
                        let icons = task.icons
                        var iconsSelected: Bool = false
                        
                        for iconId in icons{
                            let iconOpt: SOIco? = SODataFetching.sharedInstance.iconById(iconId)
                            if let ico = iconOpt{
                                iconsSelected = iconsSelected || ico.selected
                            }
                        }
                        
                        if categorySelected && iconsSelected{
                            _allTasks.append(task)
                        }
                        
                    }
                    block(resultBuffer: _allTasks, error: nil)
                })
            }
            else {
                block(resultBuffer: [], error: nil)
            }
        })
    }
    
    private func fetchAllDataWithClassName(className: String, block: (resultBuffer: [AnyObject], error: NSError?) -> Void){
        SOParseComManager.checkUser { (checkError) -> Void in
            if let error = checkError{
                block(resultBuffer: [], error: error)
            } else {
                let query = PFQuery(className: className)
                query.findObjectsInBackgroundWithBlock {(objects, fetchError) in
                    var resultBuffer: [AnyObject] = []
                    if let anError = fetchError {
                        block(resultBuffer: resultBuffer, error: anError)
                    } else {
                        if let pfObjects: [PFObject] = objects as? [PFObject]{
                            if pfObjects.count > 0{
                                pfObjects.map({object in
                                    resultBuffer.append(self.newInstanceFactory(object, className: className)!)
                                })
                                block(resultBuffer: resultBuffer, error: nil)
                            } else {
                                self.populateDefaultData(className, block: {(populateError: NSError?) -> Void in

                                    if let anError = populateError{
                                        block(resultBuffer: resultBuffer, error: anError)
                                    } else {
                                        self.fetchAllDataWithClassName(className, block: block)
                                    }
                                })
                            }
                        }
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
        
        newInstance.initFromParseObject(object)
        
        return newInstance
    }
}

    // MARK: -
    // MARK: - Save Data

extension SORemoteDataBase{
    
    public func saveTask(task: SOTask, block: (error: NSError?) -> Void){
        dispatch_sync(self.queue, {[weak self] in
            var object: PFObject? = task.databaseObject as? PFObject
            
            if let taskObject = object{
                task.copyToParseObject(taskObject)
            } else {
                object = PFObject(className: TaskClassName)
                task.databaseObject = object
                task.copyToParseObject(object!)
            }
            
            self!.saveObject(object!, block: {(error: NSError?) in
                block(error: error)
            })
            })
    }

    private func saveObject(object: PFObject, block: (error: NSError?) -> Void){
        SOParseComManager.checkUser { (checkError) -> Void in
            if let error = checkError{
                block(error: error)
            } else {
                object.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
                    if (success) {
                        block(error: nil)
                    } else {
                        block(error: error)
                    }
                }
            }
        }
    }

    public func saveFieldValueToObject(dataBaseObject: AnyObject?, entityName: String, fldName: String, recordId: String?, value: AnyObject, block: (error: NSError?) -> Void){
        self.saveFieldToObject(dataBaseObject, fieldName: fldName, value: value, block: {(error: NSError?) in
            block(error: error)
        })
    }
    
    public func saveFieldToObject(object: AnyObject?, fieldName: String, value: AnyObject, block: (error: NSError?) -> Void){
        if let pfObject = object as? PFObject{
            pfObject[fieldName] = value
            self.saveObject(pfObject, block: {(error: NSError?) in
                block(error: error)
            })
        }
    }
    
    public func saveContext() {
        
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

    // - MARK: -
    // - MARK: Fill a default data to the local database

extension SORemoteDataBase{
    
    private func populateDefaultData(className: String, block: (error: NSError?) -> Void){
        switch className{
        case IcoClassName:
            self.populateIcons{(populateError: NSError?) -> Void in
                block(error: populateError)
            }
        case CategoryClassName:
            self.populateCategories{(populateError: NSError?) -> Void in
                block(error: populateError)
            }
        case TaskClassName:
            self.populateTasks{(populateError: NSError?) -> Void in
                block(error: populateError)
            }
        default:
            return
        }
    }
    
    // - MARK: Categories
    private func populateCategories(block: (error: NSError?) -> Void){
        self.currentCategoryIndex = 0
        self.populateNextCategory{(error: NSError?) -> Void in
            block(error: error)
        }
    }

    private func populateNextCategory(block: (error: NSError?) -> Void){
        if !(self.populateNextCategoryInBackground{(error: NSError?) -> Void in
            if error == nil{
                self.populateNextCategory(block)
            } else {
                block(error: error)
            }
            }){
                block(error: nil)
        }
    }
    
    private func populateNextCategoryInBackground(block: (error: NSError?) -> Void) -> Bool{
        let defaultCategories = [
            SOCategory(id:"1", name:"ToDo".localized, selected: true),
            SOCategory(id:"2", name:"Events".localized, selected: true),
            SOCategory(id:"3", name:"Life".localized, selected: true),
            SOCategory(id:"4", name:"Work".localized, selected: true)]
        
        if self.currentCategoryIndex < defaultCategories.count{
            let category: SOCategory = defaultCategories[self.currentCategoryIndex++]
            var object = PFObject(className: CategoryClassName)
            object[kFldRecordId] = category.recordid
            object[kCategoryFldName] = category.name
            object[kFldSelected] = category.selected
            object[kFldVisible] = true
            object.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
                if (success) {
                    block(error: nil)
                } else {
                    block(error: error)
                }
            }
        } else {
            return false
        }
        
        return true
    }

    // - MARK: Icons
    private func populateIcons(block: (error: NSError?) -> Void){
        self.currentIcoIndex = 0
        self.populateNextIco{(error: NSError?) -> Void in
            block(error: error)
        }
    }
    
    private func populateNextIco(block: (error: NSError?) -> Void){
        if !(self.populateNextIcoInBackground{(error: NSError?) -> Void in
            if error == nil{
                self.populateNextIco(block)
            } else {
                block(error: error)
            }
            }){
                block(error: nil)
        }
    }
    
    private func populateNextIcoInBackground(block: (error: NSError?) -> Void) -> Bool{
        let defaultIcons = [
            SOIco(id:"1", name:"ico1".localized, imageName: "ico1", selected: true),
            SOIco(id:"2", name:"ico2".localized, imageName: "ico2", selected: true),
            SOIco(id:"3", name:"ico3".localized, imageName: "ico3", selected: true),
            SOIco(id:"4", name:"ico4".localized, imageName: "ico4", selected: true),
            SOIco(id:"5", name:"ico5".localized, imageName: "ico5", selected: true),
            SOIco(id:"6", name:"ico6".localized, imageName: "ico6", selected: true),
            SOIco(id:"7", name:"ico7".localized, imageName: "ico7", selected: true),
            SOIco(id:"8", name:"ico8".localized, imageName: "ico8", selected: true),
            SOIco(id:"9", name:"ico9".localized, imageName: "ico9", selected: true),
            SOIco(id:"10", name:"ico10".localized, imageName: "ico10", selected: true),
            SOIco(id:"11", name:"ico11".localized, imageName: "ico11", selected: true),
            SOIco(id:"12", name:"ico12".localized, imageName: "ico12", selected: true),
            SOIco(id:"13", name:"ico13".localized, imageName: "ico13", selected: true),
            SOIco(id:"14", name:"ico14".localized, imageName: "ico14", selected: true),
            SOIco(id:"15", name:"ico15".localized, imageName: "ico15", selected: true),
            SOIco(id:"16", name:"ico16".localized, imageName: "ico16", selected: true),
            SOIco(id:"17", name:"ico17".localized, imageName: "ico17", selected: true)]
        
        if self.currentIcoIndex < defaultIcons.count{
            let ico: SOIco = defaultIcons[self.currentIcoIndex++]
            var object = PFObject(className: IcoClassName)
            object[kFldRecordId] = ico.recordid
            object[kIcoFldName] = ico.name
            object[kIcoFldImageName] = ico.imageName
            object[kFldSelected] = ico.selected
            object[kFldVisible] = true
            object.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
                if (success) {
                    block(error: nil)
                } else {
                    block(error: error)
                }
            }
        } else {
            return false
        }
        
        return true
    }
    
    // - MARK: Tasks
    private func populateTasks(block: (error: NSError?) -> Void){
        self.currentTaskIndex = 0
        self.populateNextTask{(error: NSError?) -> Void in
            block(error: error)
        }
    }

    private func populateNextTask(block: (error: NSError?) -> Void){
        if !(self.populateNextTaskInBackground{(error: NSError?) -> Void in
            if error == nil{
                self.populateNextTask(block)
            } else {
                block(error: error)
            }
            }){
                block(error: nil)
        }
    }
    
    private func populateNextTaskInBackground(block: (error: NSError?) -> Void) -> Bool{
        let defaultTasks : [Dictionary<String, String>] = [
            [kTaskFldCategory: "1",
                kTaskFldIco1: "1",
                kTaskFldIco2: "3",
                kTaskFldIco3: "6",
                kTaskFldIco4: "2",
                kTaskFldIco5: "",
                kTaskFldIco6: "",
                kTaskFldTitle: "ToDo task"],
            [kTaskFldCategory: "2",
                kTaskFldIco1: "12",
                kTaskFldIco2: "11",
                kTaskFldIco3: "2",
                kTaskFldIco4: "1",
                kTaskFldIco5: "",
                kTaskFldIco6: "",
                kTaskFldTitle: "Events task"],
            [kTaskFldCategory: "3",
                kTaskFldIco1: "1",
                kTaskFldIco2: "3",
                kTaskFldIco3: "6",
                kTaskFldIco4: "2",
                kTaskFldIco5: "",
                kTaskFldIco6: "",
                kTaskFldTitle: "Life task"]]

        if self.currentTaskIndex < defaultTasks.count{
            var object = PFObject(className: TaskClassName)
            let dict: Dictionary<String, String> = defaultTasks[self.currentTaskIndex++]
            object[kTaskFldCategory] = dict[kTaskFldCategory]
            object[kTaskFldIco1] = dict[kTaskFldIco1]
            object[kTaskFldIco2] = dict[kTaskFldIco2]
            object[kTaskFldIco3] = dict[kTaskFldIco3]
            object[kTaskFldIco4] = dict[kTaskFldIco4]
            object[kTaskFldIco5] = dict[kTaskFldIco5]
            object[kTaskFldIco6] = dict[kTaskFldIco6]
            object[kTaskFldTitle] = dict[kTaskFldTitle]
            object[kTaskFldDate] = NSDate()
            object.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
                if (success) {
                    block(error: nil)
                } else {
                    block(error: error)
                }
            }
        } else {
            return false
        }
        
        return true
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
