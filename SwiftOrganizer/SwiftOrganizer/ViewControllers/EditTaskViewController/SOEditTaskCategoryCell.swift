//
//  SOEditTaskCategoryCell.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOEditTaskCategoryCell: SOEditTaskCell {

    @IBOutlet weak var categoryNameLabel: UILabel!

    override var task: SOTask{
        get{
            return super.task
        }
        set{
            super.task = newValue
            
            if newValue.categoryName == "" {
                self.categoryNameLabel.text = "Category".localized
            }
            else{
                self.categoryNameLabel.text = newValue.categoryName
            }
        }
    }
    
    override func stringData() -> String{
        return self.categoryNameLabel.text!
    }
    
}
