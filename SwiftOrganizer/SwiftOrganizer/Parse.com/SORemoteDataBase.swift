//
//  SORemoteDataBase.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

public class SORemoteDataBase: NSObject {
    
    static let sharedInstance = SORemoteDataBase()
    
    private func populateTasks(){
//        let task  = self.newTaskManagedObject()
//        task.category = "1"
//        task.ico1 = "1"
//        task.ico2 = "3"
//        task.ico3 = "6"
//        task.ico4 = "2"
//        task.ico5 = ""
//        task.ico6 = ""
//        task.title = "ToDo task"
//
//
//        let task2  = self.newTaskManagedObject()
//        task2.category = "2"
//        task2.ico1 = "6"
//        task2.ico2 = "4"
//        task2.ico3 = "3"
//        task2.ico4 = "2"
//        task2.ico5 = "1"
//        task2.ico6 = ""
//        task2.title = "Event task"
//
//        let task3  = self.newTaskManagedObject()
//        task3.category = "3"
//        task3.ico1 = "10"
//        task3.ico2 = "12"
//        task3.ico3 = "3"
//        task3.ico4 = "2"
//        task3.ico5 = ""
//        task3.ico6 = ""
//        task3.title = "Life task"
//
//        let task4  = self.newTaskManagedObject()
//        task4.category = "4"
//        task4.ico1 = "1"
//        task4.ico2 = "17"
//        task4.ico3 = ""
//        task4.ico4 = "2"
//        task4.ico5 = ""
//        task4.ico6 = ""
//        task4.title = "Work task"
//        
//        saveContext()
    }

    private func populateIcons(){
//        let icons : [Dictionary<String, String>] = [["id":"1","name":"ico1","img":"ico1"],
//            ["id":"2","name":"ico2","img":"ico2"],
//            ["id":"3","name":"ico3","img":"ico3"],
//            ["id":"4","name":"ico4","img":"ico4"],
//            ["id":"5","name":"ico5","img":"ico5"],
//            ["id":"6","name":"ico6","img":"ico6"],
//            ["id":"7","name":"ico7","img":"ico7"],
//            ["id":"8","name":"ico8","img":"ico8"],
//            ["id":"9","name":"ico9","img":"ico9"],
//            ["id":"10","name":"ico10","img":"ico10"],
//            ["id":"11","name":"ico11","img":"ico11"],
//            ["id":"12","name":"ico12","img":"ico12"],
//            ["id":"13","name":"ico13","img":"ico13"],
//        ["id":"14","name":"ico14","img":"ico14"],
//        ["id":"15","name":"ico15","img":"ico15"],
//        ["id":"16","name":"ico16","img":"ico16"],
//        ["id":"17","name":"ico17","img":"ico17"]]
//        let entityName = NSStringFromClass(Ico.classForCoder())
//
//        for dict in icons{
//            let ico = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext!) as! Ico
//            ico.id = dict["id"]!
//            ico.name = dict["name"]!
//            ico.imagename = dict["img"]!
//            ico.selected = true
//        }
//
//        saveContext()
    }
    
    private func populateCategories(){
//        let categories = ["ToDo".localized, "Events".localized, "Life".localized, "Work".localized]
//        var categoryId = 1
//        let entityName = NSStringFromClass(Category.classForCoder())
//        
//        for catagoryName in categories{
//            let category = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext!) as! Category
//            let newCategoryId = "\(categoryId++)"
//            category.id = newCategoryId
//            category.name = catagoryName as String
//            category.selected = true
//        }
//        
//        saveContext()
    }

    // - MARK: Categories
    func allCategories() -> [SOCategory]{
        var _allCategories: [SOCategory] = []
        
        return _allCategories
    }
    
    // - MARK: Icons
    func allIcons() -> [SOIco]{
        var _allIcon: [SOIco] = []
        
        return _allIcon
    }
    
    // - MARK: Tasks
    func fetchAllTasks(successBlock: (allTaskData: [SOTask], error: NSErrorPointer) -> Void) {
        func fetchAllTasks() -> Bool{
            var _allTasks: [SOTask] = []
            
            var fetchError: NSError?
            successBlock(allTaskData: _allTasks, error: &fetchError)
            
            if let error = fetchError{
                if error.code > 0{
                    assert(false, "Failed to execute the fetch request \(error.localizedDescription)")
                }
            }
            
            return true
        }
        
        if !fetchAllTasks() {
            self.populateTasks()
            fetchAllTasks()
    }
    

    }

    // MARK: - Saving support
    func saveContext() {
    
    }

    func deleteObject()
    {

    }
    
}
