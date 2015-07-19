//
//  Category.swift
//  
//
//  Created by Sergey Krotkih on 5/29/15.
//
//

import Foundation
import CoreData

@objc(TaskCategory)
class TaskCategory: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var selected: Bool

}
