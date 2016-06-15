//
//  Task+CoreDataProperties.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 10/16/15.
//  Copyright © 2015 Sergey Krotkih. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ManagedTask {

    @NSManaged var date: NSDate?
    @NSManaged var title: String?
    @NSManaged var userid: String?
    @NSManaged var icons: NSSet?
    @NSManaged var category: ManagedCategory?

}
