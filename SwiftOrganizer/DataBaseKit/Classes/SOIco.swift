//
//  Ico.swift
//  
//
//  Created by Sergey Krotkih on 5/29/15.
//
//

import UIKit

public class SOIco: NSObject {

    private var _databaseObject: AnyObject?
    private var _id: String = ""
    private var _name: String = ""
    private var _imageName: String = ""
    private var _selected = false

    convenience init(id: String, name: String, imageName: String, selected: Bool) {
        self.init()
        
        self.id = id
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
    
    public var id: String{
        get{
            return _id
        }
        set{
            self._id = newValue
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

extension SOIco{
    func initFromParseObject(object: PFObject)
    {
        self.databaseObject = object
        self.id = object["recordid"] as! String
        self.name = object["name"] as! String
        self.imageName = object["imageName"] as! String
        self.selected = object["selected"] as! Bool
    }
    
    func copyToParseObject(object: PFObject){
    }

    func initFromCoreDataObject(object: TaskIco)
    {
        self.databaseObject = object
        self.id = object.id
        self.name = object.name
        self.imageName = object.imagename
        self.selected = object.selected
    }
}

extension SOIco{
    public func didSelect(select: Bool, block: (error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.saveFieldToObject(self.databaseObject, fieldName: "selected", value: select, block: {(error: NSError?) in
            block(error: error)
        })
    }
}
