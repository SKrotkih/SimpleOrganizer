//
//  SOCatalog.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import Parse

public class SOCatalog: NSObject{

    public var databaseObject: AnyObject?
    public var recordid: String = ""
    public var selected: Bool = false
    public var visible: Bool = false

    override init() {
        super.init()

    }
    
    public var entityName: String{
        return ""
    }
}

extension SOCatalog{

    public func setSelected(select: Bool, completionBlock: (error: NSError?) -> Void){
        self.saveFldName(kFldSelected, value: select, completionBlock: completionBlock)
    }
    
    public func setVisible(visible: Bool, completionBlock: (error: NSError?) -> Void){
        self.saveFldName(kFldVisible, value: visible, completionBlock: completionBlock)
    }

    public func saveFldName(fldName: String, value: AnyObject, completionBlock: (error: NSError?) -> Void){
        let dataBase: SODataBaseProtocol = SODataBaseFactory.sharedInstance.dataBase
        dataBase.saveFieldValueToObject(self.databaseObject, entityName: self.entityName, fldName: fldName, recordId: self.recordid, value: value, completionBlock: {(error: NSError?) in
            completionBlock(error: error)
        })
    }
}
