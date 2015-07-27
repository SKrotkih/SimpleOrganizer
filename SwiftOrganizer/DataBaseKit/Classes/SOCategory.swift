//
//  SOCategory.swift
//  
//
//  Created by Sergey Krotkih on 5/29/15.
//
//

import UIKit

public class SOCategory: NSObject {
    
    private var _databaseObject: AnyObject?
    private var _id: String = ""
    private var _name: String = ""
    private var _selected = false

    override init() {
        super.init()
    }
    
    convenience init(id: String, name: String, selected: Bool) {
        self.init()
        
        self.id = id
        self.name = name
        self.selected = selected
    }
    
    public var id: String{
        get{
            return _id
        }
        set{
            _id = newValue
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

    func initFromCoreDataObject(object: TaskCategory)
    {
        self.databaseObject = object
        self.id = object.id
        self.name = object.name
        self.selected = object.selected
    }
}

extension SOCategory{
    public func didSelect(select: Bool, block: (error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.saveFieldToObject(self.databaseObject, fieldName: "selected", value: select, block: {(error: NSError?) in
            block(error: error)
        })
    }
}
