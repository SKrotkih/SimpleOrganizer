//
//  Task.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

public class Task: NSObject{

    public var databaseObject: AnyObject?
    public var userid: String = ""
    public var title: String = ""
    public var category: String = ""
    public var icons: [String] = []
    public var date: NSDate?

    convenience init(object: AnyObject?, userid: String?, title: String, category: String, date: NSDate?, icons: [String]) {
        self.init()
        
        self.databaseObject = object
        self.userid = ""
        if let theUserid = userid{
            self.userid = theUserid
        }
        self.title = title
        self.category = category
        self.date = date
        
        for icon: String in icons {
            self.icons.append(icon)
        }
    }
    
    public var categoryName: String{
        let categoryId = self.category
        
        if let category = SOFetchingData.sharedInstance.categoryById(categoryId){
            return category.name
        }
        
        return ""
    }
    
    public var taskId: String?{
        return SODataBaseFactory.sharedInstance.dataBase.getRecordIdForTask(self)
    }
    
    public var iconsCount: Int {
        get {
            return icons.count
        }
    }
    
}

extension Task{

    public func save(completionBlock: (error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.saveTask(self, completionBlock: {(error: NSError?) in
            completionBlock(error: error)
        })
    }
    
    func update(){
        //       let batch = NSBatchUpdateRequest(entityName: "ManagedCategory")
        //        batch.propertiesToUpdate = [fieldName: value]
        //        // Predicate
        //        batch.predicate = NSPredicate(format: "id = %@", category.id)
        //        // Result type
        //        batch.resultType = NSBatchUpdateRequestResultType.UpdatedObjectsCountResultType
        //
        //        var batchError: NSError?
        //        let result = managedObjectContext!.executeRequest(batch, error: &batchError)
        //
        //        if result != nil{
        //            if let theResult = result as? NSBatchUpdateResult{
        //                if let numberOfAffectedPersons = theResult.result as? Int{
        //                    println("Number of categories which were updated is \(numberOfAffectedPersons)")
        //                }
        //            }
        //        }else{
        //            if let error = batchError{
        //                println("Could not perform batch request. Error = \(error)")
        //            }
        //        }
    }

}

extension Task{

    public func clearTask(){
        self.databaseObject = nil
        self.userid = ""
        self.title = ""
        self.category = ""
        self.icons = []
        self.date = nil
    }
    
    public func cloneTask(task: Task){
        self.databaseObject = task.databaseObject
        self.userid = task.userid
        self.title = task.title
        self.category = task.category
        self.icons = task.icons
        self.date = task.date
    }
    
    override public func isEqual(object: AnyObject?) -> Bool {
        if let anotherTask: Task = object as? Task{
            var isEqual: Bool = true
            isEqual = isEqual && SODataBaseFactory.sharedInstance.dataBase.areObjectsEqual(self.databaseObject, object2: anotherTask.databaseObject)
            isEqual = isEqual && self.userid == anotherTask.userid
            isEqual = isEqual && self.title == anotherTask.title
            isEqual = isEqual && self.category == anotherTask.category
            
            if let date1: NSDate = self.date, let date2: NSDate = self.date {
                isEqual = isEqual && (date1 == date2)
            }
            
            if self.icons.count == anotherTask.icons.count{
                for index in 0..<self.icons.count{
                    let s1: String = self.icons[index]
                    let s2: String = self.icons[index]
                    isEqual = isEqual && (s1 == s2)
                    
                }
            } else {
                isEqual = isEqual && false
            }
            
            return isEqual
        } else {
            return false
        }
    }
}

    // MARK: Icons

extension Task{
    public func iconImage(index: Int) -> UIImage?{
        if index < 0 || index >= self.iconsCount {
            return nil
        }
        let icoId = icons[index]
        if let ico = SOFetchingData.sharedInstance.iconById(icoId){
            let imageName : String = ico.imageName
            if let image : UIImage = UIImage(named: imageName){
                return image
            }
        }
        return nil
    }
    
    public func setIcon(index: Int, newValue: String){
        if index < icons.count{
            icons[index] = newValue
        }
    }
}
