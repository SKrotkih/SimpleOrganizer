//
//  SOMainTableViewCell.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOMainTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var dateTextLabel: UILabel!
    
    @IBOutlet weak var categoryNameView: UIView!
    @IBOutlet weak var categoryNameLabel: UILabel!

    @IBOutlet weak var icon1ImageView: UIImageView!
    @IBOutlet weak var icon2ImageView: UIImageView!
    @IBOutlet weak var icon3ImageView: UIImageView!
    @IBOutlet weak var icon4ImageView: UIImageView!
    @IBOutlet weak var icon5ImageView: UIImageView!
    @IBOutlet weak var icon6ImageView: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //- MARK: Fill DATA
    func fillTaskData(task: SOTask){
        self.titleTextLabel!.text = task.title
        self.categoryNameLabel!.text = task.category
        self.icon1ImageView.image = task.ico(0)
        self.icon2ImageView.image = task.ico(1)
        self.icon3ImageView.image = task.ico(2)
        self.icon4ImageView.image = task.ico(3)
        self.icon5ImageView.image = task.ico(4)
        self.icon6ImageView.image = task.ico(5)
        self.dateTextLabel.text = task.dateString()
    }
}
