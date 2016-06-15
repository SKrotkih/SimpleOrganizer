//
//  SOPopulateLocalDataBase.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 9/8/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

public class SOPopulateLocalDataBase {

    private var coreData: SOCoreDataProtocol
    private var localaDataBase: SOLocalDataBase
    
    init(localDataBase: SOLocalDataBase){
        self.localaDataBase = localDataBase
        self.coreData = localDataBase.coreData
    }
    
    public func populateIcons(){
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
        let entityName = NSStringFromClass(ManagedIcon.classForCoder())
        
        for dict in icons{
            let ico = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: self.coreData.managedObjectContext!) as! ManagedIcon
            ico.recordid = dict["id"]!
            ico.name = dict["name"]!
            ico.imagename = dict["img"]!
            ico.selected = true
            ico.visible = true
        }
        
        self.coreData.saveContext()
    }
    
    public func populateCategories(){
        let categories = ["ToDo".localized, "Events".localized, "Life".localized, "Work".localized]
        var categoryId = 1
        let entityName = NSStringFromClass(ManagedCategory.classForCoder())
        
        for catagoryName in categories{
            let category = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: self.coreData.managedObjectContext!) as! ManagedCategory
            let newCategoryId = "\(categoryId)"
            category.recordid = newCategoryId
            category.name = catagoryName as String
            category.selected = true
            category.visible = true
            categoryId += 1
        }
        
        self.coreData.saveContext()
    }
    
    public func populateTask(title: String, category: String, icons: [String]){
        var userId: String?
        if let curreentUser = UsersWorker.sharedInstance.currentUser{
            userId = curreentUser.userid
        }
        let managedTask  = self.coreData.newManagedObject("ManagedTask") as! ManagedTask
        
        if let category: ManagedCategory = self.localaDataBase.categoryWithId(category){
            managedTask.category = category
        }
        managedTask.title = title
        if let theUserId = userId{
            managedTask.userid = theUserId
        }
        for iconId: String in icons{
            if let icon: ManagedIcon = self.localaDataBase.iconWithId(iconId){
                let managedTaskIcon  = self.coreData.newManagedObject("ManagedTaskIcon") as! ManagedTaskIcon
                managedTaskIcon.task = managedTask
                managedTaskIcon.icon = icon
            }
            
        }
        self.coreData.saveContext()        
    }
    
    public func populateTasks(){
        self.populateTask("ToDo task", category: "1", icons: ["1", "3", "6", "2"])
        self.populateTask("Event task", category: "2", icons: ["6", "4", "3", "2", "1"])
        self.populateTask("Life task", category: "3", icons: ["10", "12", "3", "2"])
        self.populateTask("Work task", category: "4", icons: ["1", "17", "2"])
    }
    
}
