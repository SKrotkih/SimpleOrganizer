//
//  SODataBaseProtocol.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/16/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

public protocol SODataBaseProtocol{

    static func sharedInstance() -> SODataBaseProtocol
    
    func allCategories(block: (resultBuffer: [SOCategory], error: NSError?) -> Void)
    func allIcons(block: (resultBuffer: [SOIco], error: NSError?) -> Void)
    func allTasks(block: (resultBuffer: [SOTask], error: NSError?) -> Void)

    func saveTask(task: SOTask, block: (error: NSError?) -> Void)
    func removeTask(task: SOTask)

    func saveFieldToObject(object: AnyObject?, fieldName: String, value: AnyObject, block: (error: NSError?) -> Void)
    func saveContext()
    
    func areObjectsEqual(object1: AnyObject?, object2: AnyObject?) -> Bool
    
    func recordIdForTask(task: SOTask?) -> String?
}

public protocol SOConcreteObjectsProtocol: AnyObject{

func initFromParseObject(object: AnyObject)

func copyToParseObject(object: AnyObject)

func initFromCoreDataObject(object: AnyObject)

}
