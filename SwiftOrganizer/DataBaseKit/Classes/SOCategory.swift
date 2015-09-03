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
    public var visible = false

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

    // MARK: -
    // MARK: - Select Category Handler

extension SOCategory{
    public func setSelect(select: Bool, block: (error: NSError?) -> Void){
        self.saveFldName(kCategoryFldSelected, value: select, block: block)
    }
    
    public func setVisible(visible: Bool, block: (error: NSError?) -> Void){
        self.saveFldName(kFldVisible, value: visible, block: block)
    }
    
    public func saveFldName(fldName: String, value: AnyObject, block: (error: NSError?) -> Void){
        let dataBase: SODataBaseProtocol = SODataBaseFactory.sharedInstance.dataBase
        dataBase.saveFieldValueToObject(self.databaseObject, entityName: CategoryEntityName, fldName: fldName, recordId: self.recordid, value: value, block: {(error: NSError?) in
            block(error: error)
        })
    }
}
