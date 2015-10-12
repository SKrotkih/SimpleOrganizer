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
    func allTasks(completionBlock: (resultBuffer: [SOTask], error: NSError?) -> Void)
    func allCategories(completionBlock: (resultBuffer: [SOCategory], error: NSError?) -> Void)
    func allIcons(completionBlock: (resultBuffer: [SOIco], error: NSError?) -> Void)

    func categoryById(categoryId: String) -> SOCategory?
    func iconById(iconId : String) -> SOIco?
}

public final class SOFetchingData : SOFetchingDataProtocol{
    private lazy var _allCategories = [SOCategory]()
    private lazy var _allIcons = [SOIco]()
    private var collectionQueue = dispatch_queue_create("fetchDataQ", DISPATCH_QUEUE_CONCURRENT);

    public class var sharedInstance: SOFetchingDataProtocol {
        struct SingletonWrapper {
        static let sharedInstance = SOFetchingData()
        }
        return SingletonWrapper.sharedInstance;
    }
    
    private init() {
    }
    
    public func allTasks(completionBlock: (resultBuffer: [SOTask], error: NSError?) -> Void) {
        SODataBaseFactory.sharedInstance.dataBase.allTasks{(allCurrentTasks: [SOTask], error: NSError?) in
            completionBlock(resultBuffer: allCurrentTasks, error: error)
        }
    }

    public func allCategories(completionBlock: (resultBuffer: [SOCategory], error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.allCategories{(categories: [SOCategory], error: NSError?) in
            self._allCategories = categories
            completionBlock(resultBuffer: categories, error: error)
        }
    }
    
    public func allIcons(completionBlock: (resultBuffer: [SOIco], error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.allIcons{(icons: [SOIco], error: NSError?) in
            self._allIcons = icons
            completionBlock(resultBuffer: icons, error: error)
        }
    }
}

    // MARK: -

extension SOFetchingData{
    
    public func categoryById(categoryId: String) -> SOCategory?{
        for category in self._allCategories{
            if category.recordid == categoryId{
                return category
            }
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
