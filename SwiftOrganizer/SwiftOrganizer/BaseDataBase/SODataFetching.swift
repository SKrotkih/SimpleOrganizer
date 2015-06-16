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
    
    lazy var _allTasks = [SOTask]()
    lazy var _allCategories = [SOCategory]()
    lazy var _allIcons = [SOIco]()
    
    // - MARK: Categories
    var allCategories: [SOCategory]{
        get{
            
            if _allCategories.count > 0{
                return _allCategories
            }
            _allCategories = SOLocalDataBase.sharedInstance.allCategories()
            
            return _allCategories
        }
    }
    
    // - MARK: Icons
    var allIcons: [SOIco]{
        get{
            
            if _allIcons.count > 0{
                return _allIcons
            }
            _allIcons = SOLocalDataBase.sharedInstance.allIcons()

            return _allIcons
        }
    }
    
    // - MARK: Tasks
    func fetchAllTasks(successBlock: (allTaskData: [SOTask], error: NSErrorPointer) -> Void) {
        SOLocalDataBase.sharedInstance.fetchAllTasks({ (allCurrentTasks: [SOTask], error: NSErrorPointer) in
            error.memory = NSError(domain: "LocalDataBaseErrors", code: 0, userInfo: [:])
            self._allTasks = allCurrentTasks
            successBlock(allTaskData: self._allTasks, error: error)
        })
    }
    
    // - MARK: Fetch Of The Data Instance Fields
    subscript(index: Int) -> SOCategory? {
        if allCategories.count > 0 && index < allCategories.count{
            return allCategories[index]
        }
        
        return nil
    }
    
    func categoryForIndex(index: Int) -> SOCategory?{
        if allCategories.count > 0 && index < allCategories.count{
            return allCategories[index]
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
        for category in self.allCategories{
            if category.id == id{
                return category
            }
        }
        
        return nil
    }
    
    func iconForIndex(index: Int) -> SOIco?{
        if allIcons.count > 0 && index < allIcons.count{
            return allIcons[index]
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
        for ico in self.allIcons{
            if ico.id == id{
                return ico
            }
        }
        
        return nil
    }
    
    func updateCategory(category: SOCategory, fieldName: String, value: AnyObject){
        _allCategories.removeAll(keepCapacity: false)
        category.save(fieldName, value: value)
    }
    
    func updateIcon(icon: SOIco, fieldName: String, value: AnyObject){
        _allIcons.removeAll(keepCapacity: false)
        icon.save(fieldName, value: value)
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
