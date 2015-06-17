//
//  Ico.swift
//  
//
//  Created by Sergey Krotkih on 5/29/15.
//
//

import UIKit

class SOIco: NSObject {

    private var _databaseObject: AnyObject?
    private var _id: String = ""
    private var _name: String = ""
    private var _imagename: String = ""
    private var _selected = false
    
    var id: String{
        get{
            return _id
        }
        set{
            self._id = newValue
        }
    }
    
    var name: String{
        get{
            return _name
        }
        set{
            self._name = newValue
        }
    }
    
    var imageName: String{
        get{
            return _imagename
        }
        set{
            self._imagename = newValue
        }
    }
    
    var selected: Bool{
        get{
            return _selected
        }
        set{
            self._selected = newValue
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
    
    func save(fieldName: String, value: AnyObject){
        SODataBaseFactory.sharedInstance.dataBase.saveIco(self, fieldName: fieldName, value: value)
    }
}
