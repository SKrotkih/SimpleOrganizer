//
//  TaskIcon+CoreDataProperties.swift
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

extension ManagedTaskIcon {

    @NSManaged var empty: String?
    @NSManaged var task: ManagedTask
    @NSManaged var icon: ManagedIcon

}
