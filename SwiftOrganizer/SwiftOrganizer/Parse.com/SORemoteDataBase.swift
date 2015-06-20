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

public class SORemoteDataBase: NSObject, SODataBaseProtocol {
    private var currentCategoryIndex = 0
    private var currentIcoIndex = 0
    private var currentTaskIndex = 0
    
    private let defaultCategories = [["id":"1","name":"ToDo".localized],["id":"2","name":"Events".localized], ["id":"3","name":"Life".localized], ["id":"4","name":"Work".localized]]
    private let defaultIcons : [Dictionary<String, String>] = [["id":"1","name":"ico1","img":"ico1"],
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

    private func populateNextCategoryInBackground(successBlock: (error: NSError?) -> Void){
        let dict: Dictionary<String, String> = defaultCategories[self.currentCategoryIndex++]
        var object = PFObject(className: CategoryClassName)
        object["recordid"] = dict["id"]
        object["name"] = dict["name"]
        object["selected"] = true
        object.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
            if (success) {
                successBlock(error: nil)
            } else {
                successBlock(error: error)
            }
        }
    }
    
    private func populateNextIcoInBackground(successBlock: (error: NSError?) -> Void){
        let icoDict: Dictionary<String, String> = self.defaultIcons[self.currentIcoIndex++]
        var object = PFObject(className: IcoClassName)
        object["recordid"] = icoDict["id"]
        object["name"] = icoDict["name"]
        object["imageName"] = icoDict["img"]
        object["selected"] = true
        object.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
            if (success) {
                successBlock(error: nil)
            } else {
                successBlock(error: error)
            }
        }
    }

    private func populateNextTaskInBackground(successBlock: (error: NSError?) -> Void){
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
                successBlock(error: nil)
            } else {
                successBlock(error: error)
            }
        }
        
    }
    
    // - MARK: Categories
    private func populateCategories(successBlock: (error: NSError?) -> Void){
        self.currentCategoryIndex = 0
        self.populateNextCategory{(error: NSError?) -> Void in
            successBlock(error: error)
        }
    }

    private func populateNextCategory(successBlock: (error: NSError?) -> Void){
        self.populateNextCategoryInBackground{(error: NSError?) -> Void in
            if error == nil{
                if self.currentCategoryIndex < self.defaultCategories.count{
                    self.populateNextCategory(successBlock)
                } else {
                    successBlock(error: nil)
                }
            } else {
                successBlock(error: error)
            }
        }
    }
    
    func allCategories(successBlock: (resultBuffer: [SOCategory], error: NSError?) -> Void){
        self.fetchAllDataOfClassName(CategoryClassName, successBlock: {(resultBuffer: [AnyObject], error: NSError?) in
            let buffer = resultBuffer as! [SOCategory]
            successBlock(resultBuffer: buffer, error: error)
        })
    }
    
    // - MARK: Icons
    private func populateIcons(successBlock: (error: NSError?) -> Void){
        self.currentIcoIndex = 0
        self.populateNextIco{(error: NSError?) -> Void in
            successBlock(error: error)
        }
    }
    
    private func populateNextIco(successBlock: (error: NSError?) -> Void){
        self.populateNextIcoInBackground{(error: NSError?) -> Void in
            if error == nil{
                if self.currentIcoIndex < self.defaultIcons.count{
                    self.populateNextIco(successBlock)
                } else {
                    successBlock(error: nil)
                }
            } else {
                successBlock(error: error)
            }
        }
    }

    func allIcons(successBlock: (resultBuffer: [SOIco], error: NSError?) -> Void){
        self.fetchAllDataOfClassName(IcoClassName, successBlock: {(resultBuffer: [AnyObject], error: NSError?) in
            let buffer: [SOIco] = resultBuffer as! [SOIco]
            successBlock(resultBuffer: buffer, error: error)
        })
    }
    
    // - MARK: Tasks
    private func populateTasks(successBlock: (error: NSError?) -> Void){
        self.currentTaskIndex = 0
        self.populateNextTask{(error: NSError?) -> Void in
            successBlock(error: error)
        }
    }
    
    private func populateNextTask(successBlock: (error: NSError?) -> Void){
        self.populateNextTaskInBackground{(error: NSError?) -> Void in
            if error == nil{
                if self.currentTaskIndex < self.defaultTasks.count{
                    self.populateNextTask(successBlock)
                } else {
                    successBlock(error: nil)
                }
            } else {
                successBlock(error: error)
            }
        }
    }
    
    func fetchAllTasks(successBlock: (resultBuffer: [SOTask], error: NSError?) -> Void) {
        self.fetchAllDataOfClassName(TaskClassName, successBlock: {(resultBuffer: [AnyObject], fetchError: NSError?) in
            if let error = fetchError{
                successBlock(resultBuffer: [], error: error)
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
                    successBlock(resultBuffer: _allTasks, error: nil)
                })
            }
            else {
                successBlock(resultBuffer: [], error: nil)
            }
        })
    }
    
    func saveTask(task: SOTask, successBlock: (error: NSError?) -> Void){
        var object: PFObject? = task.databaseObject as? PFObject
        
        if let taskObject = object{
            self.copyTaskObject(taskObject, srcTask: task)
        } else {
            object = PFObject(className: TaskClassName)
            self.copyTaskObject(object!, srcTask: task)
        }
        
        self.saveObject(object!, successBlock: {(error: NSError?) in
            successBlock(error: error)
        })
    }

    private func copyTaskObject(object: PFObject, srcTask: SOTask){
        object["title"] = srcTask.title
        object["category"] = srcTask.category
        let icons = srcTask.icons
        object["ico1"] = icons[0]
        object["ico2"] = icons[1]
        object["ico3"] = icons[2]
        object["ico4"] = icons[3]
        object["ico5"] = icons[4]
        object["ico6"] = icons[5]
        object["date"] = srcTask.date
    }
    
    func removeTask(task: SOTask){
        
    }

    // - MARK: Private
    private func fetchAllDataOfClassName(className: String, successBlock: (resultBuffer: [AnyObject], error: NSError?) -> Void){
        SOParseComManager.checkUser { (checkError) -> Void in
            if let error = checkError{
                successBlock(resultBuffer: [], error: error)
            } else {
                let query = PFQuery(className: className)
                query.findObjectsInBackgroundWithBlock {(objects, fetchError) in
                    var resultBuffer: [AnyObject] = []
                    if let anError = fetchError {
                        successBlock(resultBuffer: resultBuffer, error: anError)
                    } else {
                        if let pfObjects: [PFObject] = objects as? [PFObject]{
                            if pfObjects.count > 0{
                                for object: PFObject in pfObjects{
                                    if let instance: AnyObject = self.newInstance(object, className: className){
                                        resultBuffer.append(instance)
                                    }
                                }
                                successBlock(resultBuffer: resultBuffer, error: nil)
                            } else {
                                self.populateDefaultData(className, successBlock: {(populateError: NSError?) -> Void in
                                    if let anError = populateError{
                                        successBlock(resultBuffer: resultBuffer, error: anError)
                                    } else {
                                        self.fetchAllDataOfClassName(className, successBlock: successBlock)
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
            newInstance.databaseObject = object
            newInstance.id = object["recordid"] as! String
            newInstance.name = object["name"] as! String
            newInstance.imageName = object["imageName"] as! String
            newInstance.selected = object["selected"] as! Bool
            
            return newInstance
        case CategoryClassName:
            var newInstance = SOCategory()
            newInstance.databaseObject = object
            newInstance.id = object["recordid"] as! String
            newInstance.name = object["name"] as! String
            newInstance.selected = object["selected"] as! Bool
            
            return newInstance
        case TaskClassName:
            var newInstance = SOTask()
            newInstance.databaseObject = object
            newInstance.category = object["category"] as! String
            newInstance.icons[0] = object["ico1"] as! String
            newInstance.icons[1] = object["ico2"] as! String
            newInstance.icons[2] = object["ico3"] as! String
            newInstance.icons[3] = object["ico4"] as! String
            newInstance.icons[4] = object["ico5"] as! String
            newInstance.icons[5] = object["ico6"] as! String
            newInstance.title = object["title"] as! String
            newInstance.date = object["date"] as! NSDate?
            
            return newInstance
        default:
            return nil
        }
    }
    
    private func populateDefaultData(className: String, successBlock: (error: NSError?) -> Void){
        switch className{
        case IcoClassName:
            self.populateIcons{(populateError: NSError?) -> Void in
                successBlock(error: populateError)
            }
        case CategoryClassName:
            self.populateCategories{(populateError: NSError?) -> Void in
                successBlock(error: populateError)
            }
        case TaskClassName:
            self.populateTasks{(populateError: NSError?) -> Void in
                successBlock(error: populateError)
            }
        default:
            return
        }
    }

    // MARK: - Saving support
    private func saveObject(object: PFObject, successBlock: (error: NSError?) -> Void){
        SOParseComManager.checkUser { (checkError) -> Void in
            if let error = checkError{
                successBlock(error: error)
            } else {
                object.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
                    if (success) {
                        successBlock(error: nil)
                    } else {
                        successBlock(error: error)
                    }
                }
            }
        }
    }

    func saveToObject(object: AnyObject?, fieldName: String, value: AnyObject, block: (error: NSError?) -> Void){
        if let pfObject = object as? PFObject{
            pfObject[fieldName] = value
            self.saveObject(pfObject, successBlock: {(error: NSError?) in
                block(error: error)
            })
        }
    }
    
    func saveContext() {
    
    }

    func deleteObject()
    {

    }
    
}
