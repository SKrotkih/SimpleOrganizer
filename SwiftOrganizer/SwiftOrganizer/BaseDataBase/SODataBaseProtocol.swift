//
//  SODataBaseProtocol.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/16/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

protocol SODataBaseProtocol{

    func allCategories(block: (resultBuffer: [SOCategory], error: NSError?) -> Void)
    func allIcons(block: (resultBuffer: [SOIco], error: NSError?) -> Void)
    func allTasks(block: (resultBuffer: [SOTask], error: NSError?) -> Void)

    func saveTask(task: SOTask, block: (error: NSError?) -> Void)
    func removeTask(task: SOTask)

    func saveFieldToObject(object: AnyObject?, fieldName: String, value: AnyObject, block: (error: NSError?) -> Void)
    func saveContext()
}