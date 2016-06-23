//
//  EditTaskCategoryCell.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class EditTaskCategoryCell: EditTaskDetailCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override func displayContent(){
        let task: Task = self.input.task

        if task.categoryName == "" {
            self.categoryNameLabel.text = "Category".localized
        }
        else{
            self.categoryNameLabel.text = task.categoryName
        }
    }
    
    override func stringData() -> String{
        return self.categoryNameLabel.text!
    }
    
}
