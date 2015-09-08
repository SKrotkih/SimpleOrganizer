//
//  SODataFetching.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/16/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

public final class SODataFetching{
    private lazy var _allTasks = [SOTask]()
    private lazy var _allCategories = [SOCategory]()
    private lazy var _allIcons = [SOIco]()
    private var collectionQueue = dispatch_queue_create("fetchDataQ", DISPATCH_QUEUE_CONCURRENT);

    public class var sharedInstance: SODataFetching {
        struct SingletonWrapper {
        static let sharedInstance = SODataFetching()
        }
        return SingletonWrapper.sharedInstance;
    }
    
    private init() {
    }

    // MARK: - Categories
    public func allCategories(block: (resultBuffer: [SOCategory], error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.allCategories{(categories: [SOCategory], error: NSError?) in
            self._allCategories = categories
            block(resultBuffer: self._allCategories, error: error)
        }
    }
    
    // MARK: -  Icons
    public func allIcons(block: (resultBuffer: [SOIco], error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.allIcons{(icons: [SOIco], error: NSError?) in
            self._allIcons = icons
            block(resultBuffer: self._allIcons, error: error)
        }
    }
    
    public func prepareAllSubTables(block: (error: NSError?) -> Void) {
        self.allCategories{(categories: [SOCategory], fetchError: NSError?) in
            if let error = fetchError{
                block(error: error)
            } else {
                self.allIcons{(resultBuffer: [SOIco], fetchError: NSError?) in
                    if let error = fetchError{
                        block(error: error)
                    } else {
                        block(error: nil)
                    }
                }
            }
        }
    }
    
    // MARK: - Tasks
    public func allTasks(block: (resultBuffer: [SOTask], error: NSError?) -> Void) {
        SODataBaseFactory.sharedInstance.dataBase.allTasks{(allCurrentTasks: [SOTask], error: NSError?) in
            self._allTasks = allCurrentTasks
            block(resultBuffer: self._allTasks, error: error)
        }
    }
}

extension SODataFetching{
    
    public func categoryName(categoryId: String) -> String?{
        if let category = self.categoryById(categoryId){
            return category.name
        }
        
        return nil
    }
    
    public func categoryById(categoryId: String) -> SOCategory?{
        for category in self._allCategories{
            if category.recordid == categoryId{
                return category
            }
        }
        
        return nil
    }
    
    public func iconImageName(iconId : String) -> String?{
        let icoOpt: SOIco? = self.iconById(iconId)
        if let ico = icoOpt{
            return ico.imageName
        }
        
        return nil
    }
    
    public func iconById(iconId : String) -> SOIco?{
        for ico in self._allIcons{
            if ico.recordid == iconId{
                return ico
            }
        }
        
        return nil
    }
}
