//
//  SOEditTaskCell.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 7/11/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOEditTaskCell: UITableViewCell {
    
    var _task: SOTask!
    
    var task: SOTask{
        get{
            return _task
        }
        set{
            _task = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func currentValueToString() -> String{
        return ""
    }
    
}
