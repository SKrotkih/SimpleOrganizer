//
//  SOEditTaskIconsCell.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOEditTaskIconsCell: SOEditTaskCell {
    @IBOutlet weak var iconsBackgroundView: UIView!
    @IBOutlet weak var textBackgroundLabel: UILabel!
    @IBOutlet weak var ico1ImageView: UIImageView!
    @IBOutlet weak var ico2ImageView: UIImageView!
    @IBOutlet weak var ico3ImageView: UIImageView!
    @IBOutlet weak var ico4ImageView: UIImageView!
    @IBOutlet weak var ico5ImageView: UIImageView!
    @IBOutlet weak var ico6ImageView: UIImageView!
    
    override var task: SOTask{
        get{
            return super.task
        }
        set{
            super.task = newValue
            
            let imagesView = [self.ico1ImageView, self.ico2ImageView, self.ico3ImageView, self.ico4ImageView, self.ico5ImageView, self.ico6ImageView]
            var count: Int = 0;
            
            for i in 0...(imagesView.count - 1) {
                let currImage: UIImage? = newValue.iconImage(i)
                let imageView: UIImageView = imagesView[i]
                
                if let image = currImage{
                    imageView.image = image
                }
                else
                {
                    imageView.image = nil
                    count++
                }
                
                if count == imagesView.count{
                    iconsBackgroundView.hidden = true
                    textBackgroundLabel.hidden = false
                }
                else{
                    iconsBackgroundView.hidden = false
                    textBackgroundLabel.hidden = true
                }
            }
        }
    }

    override func stringData() -> String{
        return ""
    }
    
}

