//
//  EditTaskIconsCell.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class EditTaskIconsCell: EditTaskDetailCell {
    @IBOutlet weak var iconsBackgroundView: UIView!
    @IBOutlet weak var textBackgroundLabel: UILabel!
    @IBOutlet weak var ico1ImageView: UIImageView!
    @IBOutlet weak var ico2ImageView: UIImageView!
    @IBOutlet weak var ico3ImageView: UIImageView!
    @IBOutlet weak var ico4ImageView: UIImageView!
    @IBOutlet weak var ico5ImageView: UIImageView!
    @IBOutlet weak var ico6ImageView: UIImageView!
    
    override func displayContent(){
        if let task: Task = self.delegate.input.task{
            let imagesView = [self.ico1ImageView, self.ico2ImageView, self.ico3ImageView, self.ico4ImageView, self.ico5ImageView, self.ico6ImageView]
            var count: Int = 0;
            
            for i in 0..<imagesView.count {
                let imageView: UIImageView = imagesView[i]

                if let currImage: UIImage = task.iconImage(i){
                    imageView.image = currImage
                } else {
                    imageView.image = nil
                    count += 1
                }
            }
            if count >= imagesView.count{
                iconsBackgroundView.hidden = true
                textBackgroundLabel.hidden = false
            }
            else{
                iconsBackgroundView.hidden = false
                textBackgroundLabel.hidden = true
            }
        } else {
            assert(false, "The Task has to be defined!")
        }
        
    }

    override func stringData() -> String{
        return ""
    }
    
}

