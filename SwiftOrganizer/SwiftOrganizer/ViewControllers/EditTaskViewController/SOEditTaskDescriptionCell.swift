//
//  SOEditTaskDescriptionCell.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOEditTaskDescriptionCell: SOEditTaskCell {
    
    @IBOutlet weak var descriptionTasklabel: UILabel!

    override var task: SOTask{
        get{
            return super.task
        }
        set{
            super.task = newValue
            
            if newValue.title == "" {
                self.descriptionTasklabel.text = "Description".localized
            }
            else{
                self.descriptionTasklabel.text = newValue.title
            }
        }
    }
    
    override func currentValueToString() -> String{
        return self.descriptionTasklabel.text!
    }
    
}
