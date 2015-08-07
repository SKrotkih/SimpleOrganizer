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

    private var _databaseObject: AnyObject?
    private var _title: String = ""
    private var _category: String = ""
    private var _icons = [String](count: MaxIconsCount, repeatedValue: "")
    private var _date: NSDate?
    
    public var maxIconsCount: Int{
        get{
            return MaxIconsCount;
        }
    }
    
    public var databaseObject: AnyObject?{
        get{
            return _databaseObject
        }
        set{
            _databaseObject = newValue
        }
    }
    
    public var title: String{
        get{
            return _title
        }
        set{
            self._title = newValue
        }
    }
    
    public var category: String{
        get{
            return self._category
        }
        set{
            self._category = newValue
        }
    }
    
    public var icons: [String]{
        get{
            return _icons
        }
        set{
            _icons = newValue
        }
    }
    
    public var date: NSDate?{
        get{
            return _date
        }
        set{
            _date = newValue
        }
    }
    
    public var categoryName: String{
        get{
            let categoryId = self._category
            
            if let returnValue = SODataFetching.sharedInstance.categoryName(categoryId){
                return returnValue
            }
            
            return ""
        }
    }
}

extension SOTask: SOConcreteObjectsProtocol{

    public func initFromParseObject(object: AnyObject)
    {
        let theObject = object as! PFObject
        self.databaseObject = theObject
        self.title = theObject[kTaskFldTitle] as! String
        self.category = theObject[kTaskFldCategory] as! String
        self.icons[0] = theObject[kTaskFldIco1] as! String
        self.icons[1] = theObject[kTaskFldIco2] as! String
        self.icons[2] = theObject[kTaskFldIco3] as! String
        self.icons[3] = theObject[kTaskFldIco4] as! String
        self.icons[4] = theObject[kTaskFldIco5] as! String
        self.icons[5] = theObject[kTaskFldIco6] as! String
        self.date = theObject[kTaskFldDate] as! NSDate?
    }
    
    public func copyToParseObject(object: AnyObject){
        let theObject = object as! PFObject
        theObject[kTaskFldTitle] = self.title
        theObject[kTaskFldCategory] = self.category
        let icons = self.icons
        theObject[kTaskFldIco1] = icons[0]
        theObject[kTaskFldIco2] = icons[1]
        theObject[kTaskFldIco3] = icons[2]
        theObject[kTaskFldIco4] = icons[3]
        theObject[kTaskFldIco5] = icons[4]
        theObject[kTaskFldIco6] = icons[5]
        theObject[kTaskFldDate] = self.date
    }

    public func copyToCoreDataObject(object: AnyObject){
        let theObject = object as! Task
        theObject.title = self.title
        theObject.category = self.category
        let icons = self.icons
        theObject.ico1 = icons[0]
        theObject.ico2 = icons[1]
        theObject.ico3 = icons[2]
        theObject.ico4 = icons[3]
        theObject.ico5 = icons[4]
        theObject.ico6 = icons[5]
        if let date = self.date{
            theObject.date = date
        }
    }
    
    public func initFromCoreDataObject(object: AnyObject)
    {
        let theObject = object as! Task

        self.databaseObject = theObject
        self.title = theObject.title
        self.category = theObject.category
        self.date = theObject.date
        
        let taskIcons = [theObject.ico1, theObject.ico2, theObject.ico3, theObject.ico4, theObject.ico5, theObject.ico6]
        var _icons = [String](count: MaxIconsCount, repeatedValue: "")
        for i in 0..<MaxIconsCount{
            _icons[i] = taskIcons[i]
        }
        self.icons = _icons
    }
}

extension SOTask{

    public func save(block: (error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.saveTask(self, block: {(error: NSError?) in
            block(error: error)
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
        self.title = ""
        self.category = ""
        self.icons = [String](count: MaxIconsCount, repeatedValue: "")
        self.date = nil
    }
    
    public func cloneTask(task: SOTask){
        self.databaseObject = task.databaseObject
        self.title = task.title
        self.category = task.category
        self.icons = task.icons
        self.date = task.date
    }
    
    override public func isEqual(object: AnyObject?) -> Bool {
        if let anotherTask: SOTask = object as? SOTask{
            var isEqual: Bool = true
            isEqual = isEqual && SODataBaseFactory.sharedInstance.dataBase.areObjectsEqual(self.databaseObject, object2: anotherTask.databaseObject)
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
        if index < _icons.count{
            let icoId = _icons[index]
            if let imageName : String = SODataFetching.sharedInstance.iconImageName(icoId){
                if let image : UIImage = UIImage(named: imageName){
                    return image
                }
            }
        }
        
        return nil
    }
    
    public func setIcon(index: Int, newValue: String){
        if index < _icons.count{
            _icons[index] = newValue
        }
    }
}
