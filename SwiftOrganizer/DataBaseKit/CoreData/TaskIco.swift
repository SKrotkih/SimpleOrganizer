//
//  Ico.swift
//  
//
//  Created by Sergey Krotkih on 5/29/15.
//
//

import Foundation
import CoreData

@objc(TaskIco)
class TaskIco: NSManagedObject {

    @NSManaged var recordid: String
    @NSManaged var name: String
    @NSManaged var imagename: String
    @NSManaged var selected: Bool    
    @NSManaged var visible: Bool
}
