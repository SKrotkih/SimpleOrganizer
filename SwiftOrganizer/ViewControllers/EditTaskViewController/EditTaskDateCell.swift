//
//  EditTaskDateCell.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class EditTaskDateCell: EditTaskDetailCell {

    @IBOutlet weak var dateTextLabel: UILabel!
    
    override func displayContent(){
        if let task: Task = self.delegate.input.task{
            if let dateEvent = task.date{
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                self.dateTextLabel.text = dateFormatter.stringFromDate(dateEvent)
            } else{
                self.dateTextLabel.text = ""
            }
        } else {
            self.dateTextLabel.text = "Undefined".localized            
        }
    }

    override func stringData() -> String{
        return self.dateTextLabel.text!
    }
    
}
