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
        let task: Task = self.input.task
        let imageViews  = [self.ico1ImageView, self.ico2ImageView, self.ico3ImageView, self.ico4ImageView, self.ico5ImageView, self.ico6ImageView]
        let _ = imageViews.map({object in
            let imageView = object as UIImageView
            imageView.image = nil
        })
        iconsBackgroundView.hidden = true
        textBackgroundLabel.hidden = false
        var fillControllersCount: Int = 0;
        for i in 0..<task.iconsCount {
            if let iconImage: UIImage = task.iconImage(i) {
                if fillControllersCount < imageViews.count {
                    let imageView: UIImageView = imageViews[fillControllersCount]
                    imageView.image = iconImage
                    fillControllersCount += 1
                } else {
                    break
                }
            }
        }
        if fillControllersCount > 0 {
            iconsBackgroundView.hidden = false
            textBackgroundLabel.hidden = true
        }
    }

    override func stringData() -> String{
        return ""
    }
    
}
