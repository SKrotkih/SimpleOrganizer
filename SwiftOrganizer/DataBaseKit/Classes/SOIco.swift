//
//  Ico.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

public class SOIco: NSObject {

    private var _databaseObject: AnyObject?
    private var _recordid: String = ""
    private var _name: String = ""
    private var _imageName: String = ""
    private var _selected = false

    convenience init(id: String, name: String, imageName: String, selected: Bool) {
        self.init()
        
        self.recordid = id
        self.name = name
        self.imageName = imageName
        self.selected = selected
    }
    
    var databaseObject: AnyObject?{
        get{
            return _databaseObject
        }
        set{
            _databaseObject = newValue
        }
    }
    
    public var recordid: String{
        get{
            return _recordid
        }
        set{
            self._recordid = newValue
        }
    }
    
    public var name: String{
        get{
            return _name
        }
        set{
            self._name = newValue
        }
    }
    
    public var imageName: String{
        get{
            return _imageName
        }
        set{
            self._imageName = newValue
        }
    }
    
    public var selected: Bool{
        get{
            return _selected
        }
        set{
            self._selected = newValue
        }
    }
}

extension SOIco: SOConcreteObjectsProtocol{
    public func initFromParseObject(object: AnyObject)
    {
        let theObject = object as! PFObject
        self.databaseObject = theObject
        self.recordid = theObject[kIcoFldId] as! String
        self.name = theObject[kIcoFldName] as! String
        self.imageName = theObject[kIcoFldImageName] as! String
        self.selected = theObject[kIcoFldSelected] as! Bool
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
    }
}

extension SOIco{
    public func didSelect(select: Bool, block: (error: NSError?) -> Void){
        let dataBase: SODataBaseProtocol = SODataBaseFactory.sharedInstance.dataBase
        var dataBaseObject: AnyObject? = self.databaseObject
        let dBaseObject: AnyObject? = dataBase.getObjectForRecordId(self.recordid, entityName: "TaskIco")
        if dBaseObject != nil{
            dataBaseObject = dBaseObject
        }
        dataBase.saveFieldToObject(dataBaseObject, fieldName: kIcoFldSelected, value: select, block: {(error: NSError?) in
            block(error: error)
        })
    }
}
