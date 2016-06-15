//
//  SOFetchingData.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/16/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//
//  Data Access Object

import UIKit

public protocol SOFetchingDataProtocol{
    func allTasks(completionBlock: (resultBuffer: [Task], error: NSError?) -> Void)
    func allCategories(completionBlock: (resultBuffer: [TaskCategory], error: NSError?) -> Void)
    func allIcons(completionBlock: (resultBuffer: [TaskIco], error: NSError?) -> Void)

    func categoryById(categoryId: String) -> TaskCategory?
    func iconById(iconId : String) -> TaskIco?
}

public final class SOFetchingData : SOFetchingDataProtocol{
    private lazy var _allCategories = [TaskCategory]()
    private lazy var _allIcons = [TaskIco]()

    public class var sharedInstance: SOFetchingDataProtocol {
        struct SingletonWrapper {
        static let sharedInstance = SOFetchingData()
        }
        return SingletonWrapper.sharedInstance;
    }
    
    private init() {
    }
    
    public func allTasks(completionBlock: (resultBuffer: [Task], error: NSError?) -> Void) {
        SODataBaseFactory.sharedInstance.dataBase.allTasks{(allCurrentTasks: [Task], error: NSError?) in
            completionBlock(resultBuffer: allCurrentTasks, error: error)
        }
    }

    public func allCategories(completionBlock: (resultBuffer: [TaskCategory], error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.allCategories{(categories: [TaskCategory], error: NSError?) in
            self._allCategories = categories
            completionBlock(resultBuffer: categories, error: error)
        }
    }
    
    public func allIcons(completionBlock: (resultBuffer: [TaskIco], error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.allIcons{(icons: [TaskIco], error: NSError?) in
            self._allIcons = icons
            completionBlock(resultBuffer: icons, error: error)
        }
    }
}

    // MARK: -

extension SOFetchingData{
    
    public func categoryById(categoryId: String) -> TaskCategory?{
        for category in self._allCategories{
            if category.recordid == categoryId{
                return category
            }
        }
        
        return nil
    }
    
    public func iconById(iconId : String) -> TaskIco?{
        for ico in self._allIcons{
            if ico.recordid == iconId{
                return ico
            }
        }
        
        return nil
    }
    
}
