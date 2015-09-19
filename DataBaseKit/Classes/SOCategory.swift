//
//  SOCategory.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import Parse

let CategoryEntityName = "TaskCategory"

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

    //- MARK: -
    //- MARK: SOConcreteObjectsProtocol
    
    public override func initWithParseObject(object: AnyObject)
    {
        let theObject = object as! PFObject
        super.initWithParseObject(theObject)
        self.name = theObject[kCategoryFldName] as! String
    }
    
    public override func copyToParseObject(object: AnyObject){
        super.copyToParseObject(object)
    }
    
    public override func initWithCoreDataObject(object: AnyObject)
    {
        super.initWithCoreDataObject(object)
        let theObject = object as! NSManagedObject
        self.name = theObject.valueForKey(kCategoryFldName) as! String
    }
}
