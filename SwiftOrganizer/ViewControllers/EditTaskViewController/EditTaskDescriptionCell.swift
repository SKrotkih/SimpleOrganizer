//
//  EditTaskDescriptionCell.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class EditTaskDescriptionCell: EditTaskDetailCell {
    
    @IBOutlet weak var descriptionTasklabel: UILabel!
    
    override func displayContent(){
        if let task: Task = self.delegate.input.task{
            if task.title == "" {
                self.descriptionTasklabel.text = "Description".localized
            }
            else{
                self.descriptionTasklabel.text = task.title
            }
        } else {
                self.descriptionTasklabel.text = "Undefined".localized
        }
    }
    
    override func stringData() -> String{
        return self.descriptionTasklabel.text!
    }
    
}
