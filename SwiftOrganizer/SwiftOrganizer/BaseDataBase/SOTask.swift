//
//  SOTask.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

let MaxIconsCount = 6

class SOTask: NSObject{

    private var _databaseObject: AnyObject?
    private var _title: String = ""
    private var _category: String = ""
    private var _icons = [String](count: MaxIconsCount, repeatedValue: "")
    private var _date: NSDate?

    var maxIconsCount: Int{
        get{
            return MaxIconsCount;
        }
    }
   
    var title: String{
        get{
            return _title
        }
        set{
            self._title = newValue
        }
    }
    
    var category: String{
        get{
            return self._category
        }
        set{
            self._category = newValue
        }
    }

    var icons: [String]{
        get{
            return _icons
        }
        set{
            _icons = newValue
        }
    }
    
    var date: NSDate?{
        get{
            return _date
        }
        set{
            _date = newValue
        }
    }

    var categoryName: String{
        get{
            let categoryId = self._category
            
            if let returnValue = SODataFetching.sharedInstance.categoryName(categoryId){
                return returnValue
            }
            
            return ""
        }
    }
    
    func iconImage(index: Int) -> UIImage?{
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

    func setIcon(index: Int, newValue: String){
        if index < _icons.count{
            _icons[index] = newValue
        }
    }
    
    var databaseObject: AnyObject?{
        get{
            return _databaseObject
        }
        set{
            _databaseObject = newValue
        }
    }

    func save(block: (error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.saveTask(self, block: {(error: NSError?) in
            block(error: error)
        })
    }
    
    func remove(){
        SODataBaseFactory.sharedInstance.dataBase.removeTask(self)
    }
    
    func update(){
        //       let batch = NSBatchUpdateRequest(entityName: "Category")
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
    func initFromParseObject(object: PFObject)
    {
        self.databaseObject = object
        self.category = object["category"] as! String
        self.icons[0] = object["ico1"] as! String
        self.icons[1] = object["ico2"] as! String
        self.icons[2] = object["ico3"] as! String
        self.icons[3] = object["ico4"] as! String
        self.icons[4] = object["ico5"] as! String
        self.icons[5] = object["ico6"] as! String
        self.title = object["title"] as! String
        self.date = object["date"] as! NSDate?
    }
    
    func copyToParseObject(object: PFObject){
        object["title"] = self.title
        object["category"] = self.category
        let icons = self.icons
        object["ico1"] = icons[0]
        object["ico2"] = icons[1]
        object["ico3"] = icons[2]
        object["ico4"] = icons[3]
        object["ico5"] = icons[4]
        object["ico6"] = icons[5]
        object["date"] = self.date
    }
    

    func copyToCoreDataObject(object: Task){
        object.title = self.title
        object.category = self.category
        let icons = self.icons
        object.ico1 = icons[0]
        object.ico2 = icons[1]
        object.ico3 = icons[2]
        object.ico4 = icons[3]
        object.ico5 = icons[4]
        object.ico6 = icons[5]
        if let date = self.date{
            object.date = date
        }
    }
    
    func initFromCoreDataObject(object: Task)
    {
        self.databaseObject = object
        self.title = object.title
        self.category = object.category
        self.date = object.date
        
        let taskIcons = [object.ico1, object.ico2, object.ico3, object.ico4, object.ico5, object.ico6]
        var _icons = [String](count: MaxIconsCount, repeatedValue: "")
        for i in 0..<MaxIconsCount{
            _icons[i] = taskIcons[i]
        }
        self.icons = _icons
    }
    
}

