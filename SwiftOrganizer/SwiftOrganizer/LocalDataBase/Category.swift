//
//  Category.swift
//  
//
//  Created by Sergey Krotkih on 5/29/15.
//
//

import Foundation
import CoreData

@objc(Category)
class Category: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String

}
