//
//  SOEditTaskDateCell.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOEditTaskDateCell: SOEditTaskCell {

    @IBOutlet weak var dateTextLabel: UILabel!
    
    override var task: Task{
        get{
            return super.task
        }
        set{
            super.task = newValue
            
            if let dateEvent = newValue.date{
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                self.dateTextLabel.text = dateFormatter.stringFromDate(dateEvent)
            } else{
                self.dateTextLabel.text = ""
            }
        }
    }

    override func stringData() -> String{
        return self.dateTextLabel.text!
    }
    
}
