//
//  SOCatalog.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

public class SOCatalog: NSObject, SOConcreteObjectsProtocol {

    public var databaseObject: AnyObject?
    public var recordid: String = ""
    public var selected: Bool = false
    public var visible: Bool = false

    override init() {
        super.init()

    }
    
    public var entityName: String{
        get{
            return ""
        }
    }

    //- MARK: -
    //- MARK: SOConcreteObjectsProtocol
    
    public func initFromParseObject(object: AnyObject)
    {
        let theObject = object as! PFObject
        self.databaseObject = theObject
        self.recordid = theObject[kFldRecordId] as! String
        self.selected = theObject[kFldSelected] as! Bool
        self.visible = theObject[kFldVisible] as! Bool
    }
    
    public func copyToParseObject(object: AnyObject){
    }
    
    public func initFromCoreDataObject(object: AnyObject)
    {
        let theObject = object as! NSManagedObject
        self.databaseObject = theObject
        self.recordid = theObject.valueForKey(kFldRecordId) as! String
        self.selected = theObject.valueForKey(kFldSelected) as! Bool
        self.visible = theObject.valueForKey(kFldVisible) as! Bool
    }
}

extension SOCatalog{

    public func setSelected(select: Bool, block: (error: NSError?) -> Void){
        self.saveFldName(kFldSelected, value: select, block: block)
    }
    
    public func setVisible(visible: Bool, block: (error: NSError?) -> Void){
        self.saveFldName(kFldVisible, value: visible, block: block)
    }

    public func saveFldName(fldName: String, value: AnyObject, block: (error: NSError?) -> Void){
        let dataBase: SODataBaseProtocol = SODataBaseFactory.sharedInstance.dataBase
        dataBase.saveFieldValueToObject(self.databaseObject, entityName: self.entityName, fldName: fldName, recordId: self.recordid, value: value, block: {(error: NSError?) in
            block(error: error)
        })
    }
}
