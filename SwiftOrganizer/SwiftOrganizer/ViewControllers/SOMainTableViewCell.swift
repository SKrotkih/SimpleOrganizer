//
//  NameAndColorCell.swift
//  TableCells
//
//  Created by Domenico on 22.04.15.
//  Copyright (c) 2015 Domenico Solazzo. All rights reserved.
//

import UIKit

class SOMainTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var categoryNameView: UIView!
    @IBOutlet weak var categoryNameLabel: UILabel!

    @IBOutlet weak var icon1ImageView: UIImageView!
    @IBOutlet weak var icon2ImageView: UIImageView!
    @IBOutlet weak var icon3ImageView: UIImageView!
    @IBOutlet weak var icon4ImageView: UIImageView!
    @IBOutlet weak var icon5ImageView: UIImageView!
    @IBOutlet weak var icon6ImageView: UIImageView!
    
    var name: String = "" {
        didSet {
            if (name != oldValue) {
                nameLabel.text = name
            }
        }
    }
    var color: String = "" {
        didSet {
            if (color != oldValue) {
                colorLabel.text = color
            }
        }
    }
    var nameLabel: UILabel!
    var colorLabel: UILabel!
    
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
    
  

}
