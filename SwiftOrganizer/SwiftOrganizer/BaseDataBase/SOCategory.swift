//
//  SOCategory.swift
//  
//
//  Created by Sergey Krotkih on 5/29/15.
//
//

import UIKit

class SOCategory: NSObject {
    
    private var _databaseObject: AnyObject?
    private var _id: String = ""
    private var _name: String = ""
    private var _selected = false

    var id: String{
        get{
            return _id
        }
        set{
            _id = newValue
        }
    }
    
    var name: String{
        get{
            return _name
        }
        set{
            _name = newValue
        }
    }
    
    var selected: Bool{
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
    
    func didSelect(select: Bool, block: (error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.saveFieldToObject(self.databaseObject, fieldName: "selected", value: select, block: {(error: NSError?) in
            block(error: error)
        })
    }
}

extension SOCategory{
    func initFromParseObject(object: PFObject)
    {
        self.databaseObject = object
        self.id = object["recordid"] as! String
        self.name = object["name"] as! String
        self.selected = object["selected"] as! Bool
    }
    
    func copyToParseObject(object: PFObject){
    }

    func initFromCoreDataObject(object: Category)
    {
        self.databaseObject = object
        self.id = object.id
        self.name = object.name
        self.selected = object.selected
    }
}
