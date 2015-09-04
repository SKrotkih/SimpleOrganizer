//
//  Ico.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

let IcoEntityName = "TaskIco"

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

    //- MARK: -
    //- MARK: SOConcreteObjectsProtocol
    
    public override func initFromParseObject(object: AnyObject)
    {
        let theObject = object as! PFObject
        super.initFromParseObject(theObject)
        self.name = theObject[kIcoFldName] as! String
        self.imageName = theObject[kIcoFldImageName] as! String
    }
    
    public override func copyToParseObject(object: AnyObject){
        super.copyToParseObject(object)
    }
    
    public override func initFromCoreDataObject(object: AnyObject)
    {
        super.initFromCoreDataObject(object)
        let theObject = object as! NSManagedObject
        self.name = theObject.valueForKey(kIcoFldName) as! String
        self.imageName = theObject.valueForKey(kIcoFldImageName) as! String
    }
}

