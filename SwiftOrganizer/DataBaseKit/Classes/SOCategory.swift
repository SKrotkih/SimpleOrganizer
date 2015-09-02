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
    private var _recordid: String = ""
    private var _name: String = ""
    private var _selected = false

    override init() {
        super.init()
    }
    
    convenience init(id: String, name: String, selected: Bool) {
        self.init()
        
        self.recordid = id
        self.name = name
        self.selected = selected
    }
    
    public var recordid: String{
        get{
            return _recordid
        }
        set{
            _recordid = newValue
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
        self.recordid = theObject[kCategoryFldId] as! String
        self.name = theObject[kCategoryFldName] as! String
        self.selected = theObject[kCategoryFldSelected] as! Bool
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
    }
}

    // MARK: -
    // MARK: - Select Category Handler

extension SOCategory{
    public func didSelect(select: Bool, block: (error: NSError?) -> Void){
        let dataBase: SODataBaseProtocol = SODataBaseFactory.sharedInstance.dataBase
        var dataBaseObject: AnyObject? = self.databaseObject
        let dBaseObject: AnyObject? = dataBase.getObjectForRecordId(self.recordid, entityName: "TaskCategory")
        
        if dBaseObject != nil{
            dataBaseObject = dBaseObject
        }
        dataBase.saveFieldToObject(dataBaseObject, fieldName: kCategoryFldSelected, value: select, block: {(error: NSError?) in
            block(error: error)
        })
    }
}
