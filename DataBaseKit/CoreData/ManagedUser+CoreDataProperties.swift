//
//  User+CoreDataProperties.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 9/28/15.
//  Copyright © 2015 Sergey Krotkih. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ManagedUser {

    @NSManaged var contact: String?
    @NSManaged var currentUser: NSNumber?
    @NSManaged var email: String?
    @NSManaged var fb_id: String?
    @NSManaged var firstname: String?
    @NSManaged var gender: String?
    @NSManaged var homeCity: String?
    @NSManaged var lastname: String?
    @NSManaged var name: String?
    @NSManaged var photo_prefix: String?
    @NSManaged var photo_suffix: String?
    @NSManaged var userid: String?
}
