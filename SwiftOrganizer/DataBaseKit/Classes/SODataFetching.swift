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
        SOObserversManager.sharedInstance.addObserver(self, type: .SODataBaseTypeChanged, priority: 998)
    }

    deinit{
        SOObserversManager.sharedInstance.removeObserver(self, type: .SODataBaseTypeChanged)
    }
    
    
    // - MARK: Categories
    public func allCategories(block: (resultBuffer: [SOCategory], error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.allCategories{(categories: [SOCategory], error: NSError?) in
            self._allCategories = categories
            block(resultBuffer: self._allCategories, error: error)
        }
    }
    
    // - MARK: Icons
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
    
    // - MARK: Tasks
    public func allTasks(block: (resultBuffer: [SOTask], error: NSError?) -> Void) {
        SODataBaseFactory.sharedInstance.dataBase.allTasks{(allCurrentTasks: [SOTask], error: NSError?) in
            self._allTasks = allCurrentTasks
            block(resultBuffer: self._allTasks, error: error)
        }
    }
    
    // - MARK: Fetch Of The Data Instance Fields
    subscript(index: Int) -> SOCategory? {
        return self.categoryForIndex(index)
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
            if category.recordid == id{
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
    
    public func iconImageName(id : String) -> String?{
        let icoOpt: SOIco? = self.iconById(id)
        if let ico = icoOpt{
            return ico.imageName
        }
        
        return nil
    }
    
    func iconById(id : String) -> SOIco?{
        for ico in self._allIcons{
            if ico.recordid == id{
                return ico
            }
        }
        
        return nil
    }
}

    // MARK: SOObserverProtocol

extension SODataFetching: SOObserverProtocol {
    public func notify(notification: SOObserverNotification){
        switch notification.type{
        case .SODataBaseTypeChanged:
            dispatch_barrier_sync(self.collectionQueue, { () in
                self._allCategories.removeAll(keepCapacity: false)
                self._allTasks.removeAll(keepCapacity: false)
                self._allIcons.removeAll(keepCapacity: false)
            });
        default:
            assert(false, "Something is wrong with observer code notification!")
        }
    }
}

