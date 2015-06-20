//
//  SODataFetching.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/16/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SODataFetching: NSObject {

    static let sharedInstance = SODataFetching()
    
    private lazy var _allTasks = [SOTask]()
    private lazy var _allCategories = [SOCategory]()
    private lazy var _allIcons = [SOIco]()
    
    // - MARK: Categories
    func allCategories(successBlock: (categories: [SOCategory], error: NSError?) -> Void){
        if _allCategories.count > 0{
            successBlock(categories: _allCategories, error: nil)
        } else {
            SODataBaseFactory.sharedInstance.dataBase.allCategories{(categories: [SOCategory], error: NSError?) in
                self._allCategories = categories
                successBlock(categories: self._allCategories, error: error)
            }
        }
    }
    
    // - MARK: Icons
    func allIcons(successBlock: (resultBuffer: [SOIco], error: NSError?) -> Void){
        if self._allIcons.count > 0{
            successBlock(resultBuffer: self._allIcons, error: nil)
        } else {
            SODataBaseFactory.sharedInstance.dataBase.allIcons{(icons: [SOIco], error: NSError?) in
                self._allIcons = icons
                successBlock(resultBuffer: self._allIcons, error: error)
            }
        }
    }
    
    // - MARK: Tasks
    func fetchAllTasks(successBlock: (resultBuffer: [SOTask], error: NSError?) -> Void) {
        SODataBaseFactory.sharedInstance.dataBase.fetchAllTasks{(allCurrentTasks: [SOTask], error: NSError?) in
            self._allTasks = allCurrentTasks
            successBlock(resultBuffer: self._allTasks, error: error)
        }
    }
    
    // - MARK: Fetch Of The Data Instance Fields
    subscript(index: Int) -> SOCategory? {
        if self._allCategories.count > 0 && index < self._allCategories.count{
            return self._allCategories[index]
        }
        
        return nil
    }
    
    func categoryForIndex(index: Int) -> SOCategory?{
        if self._allCategories.count > 0 && index < self._allCategories.count{
            return self._allCategories[index]
        }
        
        return nil
    }
    
    func categoryName(id : String) -> String?{
        if let category = self.categoryById(id){
            return category.name
        }
        
        return nil
    }
    
    func categoryById(id : String) -> SOCategory?{
        for category in self._allCategories{
            if category.id == id{
                return category
            }
        }
        
        return nil
    }
    
    func iconForIndex(index: Int) -> SOIco?{
        if self._allIcons.count > 0 && index < self._allIcons.count{
            return self._allIcons[index]
        }
        
        return nil
    }
    
    func iconsImageName(id : String) -> String?{
        let icoOpt: SOIco? = self.iconById(id)
        if let ico = icoOpt{
            return ico.imageName
        }
        
        return nil
    }
    
    func iconById(id : String) -> SOIco?{
        for ico in self._allIcons{
            if ico.id == id{
                return ico
            }
        }
        
        return nil
    }
    
    func updateCategory(category: SOCategory, fieldName: String, value: AnyObject, block: (error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.saveToObject(category.databaseObject, fieldName: fieldName, value: value, block: {(error: NSError?) in
            block(error: error)
        })
    }
    
    func updateIcon(icon: SOIco, fieldName: String, value: AnyObject, block: (error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.saveToObject(icon.databaseObject, fieldName: fieldName, value: value, block: {(error: NSError?) in
            block(error: error)
        })
    }
    
    func updateTask(){
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
