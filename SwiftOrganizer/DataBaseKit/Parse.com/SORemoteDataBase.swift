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

public class SORemoteDataBase: SODataBaseProtocol {
    private var currentCategoryIndex = 0
    private var currentIcoIndex = 0
    private var currentTaskIndex = 0

    public class func sharedInstance() -> SODataBaseProtocol{
        struct SingletonWrapper {
            static let sharedInstance = SORemoteDataBase()
        }
        return SingletonWrapper.sharedInstance;
    }
    
    private init() {
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
            object["recordid"] = category.id
            object["name"] = category.name
            object["selected"] = category.selected
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
            object["recordid"] = ico.id
            object["name"] = ico.name
            object["imageName"] = ico.imageName
            object["selected"] = ico.selected
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

    private let defaultTasks : [Dictionary<String, String>] = [
        ["category": "1",
            "ico1": "1",
            "ico2": "3",
            "ico3": "6",
            "ico4": "2",
            "ico5": "",
            "ico6": "",
            "title": "ToDo task"],
        ["category": "2",
            "ico1": "12",
            "ico2": "11",
            "ico3": "2",
            "ico4": "1",
            "ico5": "",
            "ico6": "",
            "title": "Events task"],
        ["category": "3",
            "ico1": "1",
            "ico2": "3",
            "ico3": "6",
            "ico4": "2",
            "ico5": "",
            "ico6": "",
            "title": "Life task"]]
    
    private func populateNextTaskInBackground(block: (error: NSError?) -> Void){
        var object = PFObject(className: TaskClassName)
        let dict: Dictionary<String, String> = self.defaultTasks[self.currentTaskIndex++]
        object["category"] = dict["category"]
        object["ico1"] = dict["ico1"]
        object["ico2"] = dict["ico2"]
        object["ico3"] = dict["ico3"]
        object["ico4"] = dict["ico4"]
        object["ico5"] = dict["ico5"]
        object["ico6"] = dict["ico6"]
        object["title"] = dict["title"]
        object["date"] = NSDate()
        object.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
            if (success) {
                block(error: nil)
            } else {
                block(error: error)
            }
        }
    }
    
    // - MARK: Categories
    private func populateCategories(block: (error: NSError?) -> Void){
        self.currentCategoryIndex = 0
        self.populateNextCategory{(error: NSError?) -> Void in
            block(error: error)
        }
    }

    
    public func allCategories(block: (resultBuffer: [SOCategory], error: NSError?) -> Void){
        self.fetchAllDataOfClassName(CategoryClassName, block: {(resultBuffer: [AnyObject], error: NSError?) in
            let buffer = resultBuffer as! [SOCategory]
            block(resultBuffer: buffer, error: error)
        })
    }
    
    // - MARK: Icons
    private func populateIcons(block: (error: NSError?) -> Void){
        self.currentIcoIndex = 0
        self.populateNextIco{(error: NSError?) -> Void in
            block(error: error)
        }
    }

    public func allIcons(block: (resultBuffer: [SOIco], error: NSError?) -> Void){
        self.fetchAllDataOfClassName(IcoClassName, block: {(resultBuffer: [AnyObject], error: NSError?) in
            let buffer: [SOIco] = resultBuffer as! [SOIco]
            block(resultBuffer: buffer, error: error)
        })
    }
    
    // - MARK: Tasks
    private func populateTasks(block: (error: NSError?) -> Void){
        self.currentTaskIndex = 0
        self.populateNextTask{(error: NSError?) -> Void in
            block(error: error)
        }
    }
    
    private func populateNextTask(block: (error: NSError?) -> Void){
        self.populateNextTaskInBackground{(error: NSError?) -> Void in
            if error == nil{
                if self.currentTaskIndex < self.defaultTasks.count{
                    self.populateNextTask(block)
                } else {
                    block(error: nil)
                }
            } else {
                block(error: error)
            }
        }
    }
    
    public func allTasks(block: (resultBuffer: [SOTask], error: NSError?) -> Void) {
        self.fetchAllDataOfClassName(TaskClassName, block: {(resultBuffer: [AnyObject], fetchError: NSError?) in
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
                        var iconsSelected: Bool = true
                        
                        for iconId in icons{
                            let iconOpt: SOIco? = SODataFetching.sharedInstance.iconById(iconId)
                            if let ico = iconOpt{
                                iconsSelected = iconsSelected && ico.selected
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
    
    public func saveTask(task: SOTask, block: (error: NSError?) -> Void){
        var object: PFObject? = task.databaseObject as? PFObject
        
        if let taskObject = object{
            task.copyToParseObject(taskObject)
        } else {
            object = PFObject(className: TaskClassName)
            task.copyToParseObject(object!)
        }
        
        self.saveObject(object!, block: {(error: NSError?) in
            block(error: error)
        })
    }

    public func removeTask(task: SOTask){
        if let taskObject: PFObject = task.databaseObject as? PFObject{
            self.deleteObject(taskObject)
        }
    }

    public func recordIdForTask(task: SOTask?) -> String?{
        
        return nil
    }
    
    public func areObjectsEqual(object1: AnyObject?, object2: AnyObject?) -> Bool{
        if let obj1: PFObject = object1 as? PFObject, let obj2: PFObject = object2 as? PFObject{
            return obj1 == obj2
        }

        return true
    }
    
    // - MARK: Private
    private func fetchAllDataOfClassName(className: String, block: (resultBuffer: [AnyObject], error: NSError?) -> Void){
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
                                for object: PFObject in pfObjects{
                                    if let instance: AnyObject = self.newInstance(object, className: className){
                                        resultBuffer.append(instance)
                                    }
                                }
                                block(resultBuffer: resultBuffer, error: nil)
                            } else {
                                self.populateDefaultData(className, block: {(populateError: NSError?) -> Void in
                                    if let anError = populateError{
                                        block(resultBuffer: resultBuffer, error: anError)
                                    } else {
                                        self.fetchAllDataOfClassName(className, block: block)
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func newInstance(object: PFObject, className: String) -> AnyObject?{
        switch className{
        case IcoClassName:
            var newInstance = SOIco()
            newInstance.initFromParseObject(object)
            
            return newInstance
        case CategoryClassName:
            var newInstance = SOCategory()
            newInstance.initFromParseObject(object)
            
            return newInstance
        case TaskClassName:
            var newInstance = SOTask()
            newInstance.initFromParseObject(object)
            
            return newInstance
        default:
            return nil
        }
    }
    
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

    // MARK: - Saving support
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

    private func deleteObject(object: PFObject)
    {
        object.deleteInBackground()
    }
    
    
    
    
    
}
