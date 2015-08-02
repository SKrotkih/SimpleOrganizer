//
//  SOCategory.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

public class SOCategory: NSObject {
    
    private var _databaseObject: AnyObject?
    private var _id: String = ""
    private var _name: String = ""
    private var _selected = false

    override init() {
        super.init()
    }
    
    convenience init(id: String, name: String, selected: Bool) {
        self.init()
        
        self.id = id
        self.name = name
        self.selected = selected
    }
    
    public var id: String{
        get{
            return _id
        }
        set{
            _id = newValue
        }
    }
    
    public var name: String{
        get{
            return _name
        }
        set{
            _name = newValue
        }
    }
    
    public var selected: Bool{
        get{
            return _selected
        }
        set{
            _selected = newValue
        }
    }

    var databaseObject: AnyObject?{
        get{
            return _databaseObject
        }
        set{
            _databaseObject = newValue
        }
    }
}

extension SOCategory: SOConcreteObjectsProtocol{
    public func initFromParseObject(object: AnyObject)
    {
        let theObject = object as! PFObject
        self.databaseObject = theObject
        self.id = theObject[kCategoryFldId] as! String
        self.name = theObject[kCategoryFldName] as! String
        self.selected = theObject[kCategoryFldSelected] as! Bool
    }
    
    public func copyToParseObject(object: AnyObject){
    }

    public func initFromCoreDataObject(object: AnyObject)
    {
        let theObject = object as! TaskCategory
        self.databaseObject = theObject
        self.id = theObject.id
        self.name = theObject.name
        self.selected = theObject.selected
    }
}

extension SOCategory{
    public func didSelect(select: Bool, block: (error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.saveFieldToObject(self.databaseObject, fieldName: kCategoryFldSelected, value: select, block: {(error: NSError?) in
            block(error: error)
        })
    }
}
