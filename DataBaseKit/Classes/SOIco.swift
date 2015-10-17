//
//  Ico.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

let IcoEntityName = "Icon"

public class SOIco: SOCatalog {

    public var name: String = ""
    public var imageName: String = ""

    convenience init(object: AnyObject?, id: String, selected: Bool, visible: Bool, name: String, imageName: String) {
        self.init()
        
        self.databaseObject = object
        self.recordid = id
        self.selected = selected
        self.visible = visible
        
        self.name = name
        self.imageName = imageName

    }
    
    public override var entityName: String{
        return IcoEntityName
    }
}
