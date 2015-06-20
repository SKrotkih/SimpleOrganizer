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
}
