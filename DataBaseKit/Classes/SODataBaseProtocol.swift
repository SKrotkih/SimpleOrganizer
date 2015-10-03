//
//  SODataBaseProtocol.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/16/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

public protocol SODataBaseProtocol{

    func chainResponsibility(dataBaseIndex: DataBaseIndex) -> SODataBaseProtocol
    
    func allCategories(completionBlock: (resultBuffer: [SOCategory], error: NSError?) -> Void)
    func allIcons(completionBlock: (resultBuffer: [SOIco], error: NSError?) -> Void)
    func allTasks(completionBlock: (resultBuffer: [SOTask], error: NSError?) -> Void)

    func saveTask(task: SOTask, completionBlock: (error: NSError?) -> Void)
    func removeTask(task: SOTask)

    func saveFieldValueToObject(dataBaseObject: AnyObject?, entityName: String, fldName: String, recordId: String?, value: AnyObject, completionBlock: (error: NSError?) -> Void)
    
    func saveFieldToObject(object: AnyObject?, fieldName: String, value: AnyObject, completionBlock: (error: NSError?) -> Void)
    
    func areObjectsEqual(object1: AnyObject?, object2: AnyObject?) -> Bool
    
    func getRecordIdForTask(task: SOTask?) -> String?
    
    func getObjectForRecordId(recordid: String, entityName: String) -> AnyObject?
}

public protocol SOConcreteObjectsProtocol: AnyObject{
    func initWithParseObject(object: AnyObject)
    func copyToParseObject(object: AnyObject)
    func initWithCoreDataObject(object: AnyObject)
}