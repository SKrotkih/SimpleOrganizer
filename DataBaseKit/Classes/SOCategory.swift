//
//  SOCategory.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

let CategoryEntityName = "TaskCategory"

public class SOCategory: SOCatalog {
    
    public var name: String = ""
    
    convenience init(object: AnyObject?, id: String, selected: Bool, visible: Bool, name: String) {
        self.init()
        
        self.databaseObject = object
        self.recordid = id
        self.selected = selected
        self.visible = visible
        
        self.name = name
    }
    
    public override var entityName: String{
        return CategoryEntityName
    }
}
