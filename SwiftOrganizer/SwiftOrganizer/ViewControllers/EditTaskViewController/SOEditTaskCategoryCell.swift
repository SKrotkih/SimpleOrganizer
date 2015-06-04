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
            if newValue.category == "" {
                self.categoryNameLabel.text = "Category".localized
            }
            else{
                self.categoryNameLabel.text = newValue.category
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

