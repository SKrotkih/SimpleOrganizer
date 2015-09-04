//
//  Ico.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

public class SOIco: SOCatalog {

    public var name: String = ""
    public var imageName: String = ""

    convenience init(id: String, name: String, imageName: String, selected: Bool) {
        self.init()
        
        self.recordid = id
        self.selected = selected
        
        self.name = name
        self.imageName = imageName
    }
    
    public override var entityName: String{
        get{
            return IcoEntityName
        }
    }
}

extension SOIco: SOConcreteObjectsProtocol{
    public func initFromParseObject(object: AnyObject)
    {
        let theObject = object as! PFObject
        self.databaseObject = theObject
        self.recordid = theObject[kFldRecordId] as! String
        self.name = theObject[kIcoFldName] as! String
        self.imageName = theObject[kIcoFldImageName] as! String
        self.selected = theObject[kFldSelected] as! Bool
        self.visible = theObject[kFldVisible] as! Bool
    }
    
    public func copyToParseObject(object: AnyObject){
    }

    public func initFromCoreDataObject(object: AnyObject)
    {
        let theObject = object as! TaskIco
        self.databaseObject = theObject
        self.recordid = theObject.recordid
        self.name = theObject.name
        self.imageName = theObject.imagename
        self.selected = theObject.selected
        self.visible = theObject.visible
    }
}
