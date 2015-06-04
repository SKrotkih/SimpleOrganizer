//
//  Task.swift
//  
//
//  Created by Sergey Krotkih on 6/4/15.
//
//

import Foundation
import CoreData

@objc(Task)
class Task: NSManagedObject {

    @NSManaged var category: String
    @NSManaged var ico1: String
    @NSManaged var ico2: String
    @NSManaged var ico3: String
    @NSManaged var ico4: String
    @NSManaged var ico5: String
    @NSManaged var ico6: String
    @NSManaged var title: String
    @NSManaged var date: NSDate

}
