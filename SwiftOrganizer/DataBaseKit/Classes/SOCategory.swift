//
//  SOCategory.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

public class SOCategory: SOCatalog {
    
    public var name: String = ""
    
    convenience init(id: String, name: String, selected: Bool) {
        self.init()
        
        self.recordid = id
        self.selected = selected

        self.name = name
    }
    
    public override var entityName: String{
        get{
            return CategoryEntityName
        }
    }
    
}

extension SOCategory: SOConcreteObjectsProtocol{
    public func initFromParseObject(object: AnyObject)
    {
        let theObject = object as! PFObject
        self.databaseObject = theObject
        self.recordid = theObject[kFldRecordId] as! String
        self.name = theObject[kCategoryFldName] as! String
        self.selected = theObject[kFldSelected] as! Bool
        self.visible = theObject[kFldVisible] as! Bool
    }
    
    public func copyToParseObject(object: AnyObject){
    }

    public func initFromCoreDataObject(object: AnyObject)
    {
        let theObject = object as! TaskCategory
        self.databaseObject = theObject
        self.recordid = theObject.recordid
        self.name = theObject.name
        self.selected = theObject.selected
        self.visible = theObject.visible
    }
}
