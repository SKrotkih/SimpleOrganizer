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
    
    func allCategories(completionBlock: (resultBuffer: [TaskCategory], error: NSError?) -> Void)
    func allIcons(completionBlock: (resultBuffer: [TaskIco], error: NSError?) -> Void)
    func allTasks(completionBlock: (resultBuffer: [Task], error: NSError?) -> Void)

    func saveTask(task: Task, completionBlock: (error: NSError?) -> Void)
    func removeTask(taskID: AnyObject)

    func taskForObjectID(objectID: AnyObject) -> Task?
    
    func saveFieldValueToObject(dataBaseObject: AnyObject?, entityName: String, fldName: String, recordId: String?, value: AnyObject, completionBlock: (error: NSError?) -> Void)
    
    func saveFieldToObject(object: AnyObject?, fieldName: String, value: AnyObject, completionBlock: (error: NSError?) -> Void)
    
    func areObjectsEqual(object1: AnyObject?, object2: AnyObject?) -> Bool
    
    func getRecordIdForTask(task: Task?) -> String?
    
    func getObjectForRecordId(recordid: String, entityName: String) -> AnyObject?
}
