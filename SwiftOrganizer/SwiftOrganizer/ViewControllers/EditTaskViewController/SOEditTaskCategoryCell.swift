//
//  SOEditTaskCategoryCell.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOEditTaskCategoryCell: UITableViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!

    var task: SOTask{
        get{
            return SOTask()            
        }
        set{
            if newValue.categoryName == "" {
                self.categoryNameLabel.text = "Category".localized
            }
            else{
                self.categoryNameLabel.text = newValue.categoryName
            }
        }
    }
}
