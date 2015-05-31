//
//  Ico.swift
//  
//
//  Created by Sergey Krotkih on 5/29/15.
//
//

import Foundation
import CoreData

@objc(Ico)
class Ico: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var imagename: String
    @NSManaged var selected: Bool    

}
