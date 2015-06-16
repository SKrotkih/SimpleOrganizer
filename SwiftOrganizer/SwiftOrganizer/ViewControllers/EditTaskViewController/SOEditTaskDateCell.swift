//
//  SOEditTaskDateCell.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOEditTaskDateCell: UITableViewCell {

    @IBOutlet weak var dateTextLabel: UILabel!
    
    var task: SOTask{
        get{
            return SOTask()            
        }
        set{
            if let dateEvent = newValue.date{
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                self.dateTextLabel.text = dateFormatter.stringFromDate(dateEvent)
            } else{
                self.dateTextLabel.text = ""
            }
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
    
}
