//
//  SODataBaseProtocol.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/16/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

protocol SODataBaseProtocol{

    func allCategories(successBlock: (resultBuffer: [SOCategory], error: NSError?) -> Void)
    func saveCategory(category: SOCategory, fieldName: String, value: AnyObject)
    
    func allIcons(successBlock: (resultBuffer: [SOIco], error: NSError?) -> Void)
    func saveIco(ico: SOIco, fieldName: String, value: AnyObject)
    
    func fetchAllTasks(successBlock: (resultBuffer: [SOTask], error: NSError?) -> Void)
    func saveTask(task: SOTask, successBlock: (error: NSError?) -> Void)
    func removeTask(task: SOTask)
    
    func saveContext()
    
}
