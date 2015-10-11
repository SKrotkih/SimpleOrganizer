//
//  SOTask.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

let MaxIconsCount = 6

public class SOTask: NSObject{

    public var databaseObject: AnyObject?
    public var userid: String = ""
    public var title: String = ""
    public var category: String = ""
    public var icons: [String] = [String](count: MaxIconsCount, repeatedValue: "")
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
        self.icons[0] = icons[0]
        self.icons[1] = icons[1]
        self.icons[2] = icons[2]
        self.icons[3] = icons[3]
        self.icons[4] = icons[4]
        self.icons[5] = icons[5]
    }
    
    public var maxIconsCount: Int{
        return MaxIconsCount;
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
    
}

extension SOTask{

    public func save(completionBlock: (error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.saveTask(self, completionBlock: {(error: NSError?) in
            completionBlock(error: error)
        })
    }
    
    public func remove(){
        SODataBaseFactory.sharedInstance.dataBase.removeTask(self)
    }
    
    func update(){
        //       let batch = NSBatchUpdateRequest(entityName: "TaskCategory")
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

extension SOTask{

    public func clearTask(){
        self.databaseObject = nil
        self.userid = ""
        self.title = ""
        self.category = ""
        self.icons = [String](count: MaxIconsCount, repeatedValue: "")
        self.date = nil
    }
    
    public func cloneTask(task: SOTask){
        self.databaseObject = task.databaseObject
        self.userid = task.userid
        self.title = task.title
        self.category = task.category
        self.icons = task.icons
        self.date = task.date
    }
    
    override public func isEqual(object: AnyObject?) -> Bool {
        if let anotherTask: SOTask = object as? SOTask{
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

extension SOTask{
    public func iconImage(index: Int) -> UIImage?{
        if index < icons.count{
            let icoId = icons[index]
            
            let ico: SOIco? = SOFetchingData.sharedInstance.iconById(icoId)
            if let theIco = ico{
                let imageName : String = theIco.imageName

                if let image : UIImage = UIImage(named: imageName){
                    return image
                }
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
