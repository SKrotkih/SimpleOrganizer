//
//  SOEditTaskCell.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 7/11/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOEditTaskCell: UITableViewCell {
    
    private var _task: Task!
    
    var task: Task{
        get{
            return _task
        }
        set{
            _task = newValue
        }
    }

    func stringData() -> String{
        assert(false, "You should to override this method in a child class!")
        
        return ""
    }
    
}
