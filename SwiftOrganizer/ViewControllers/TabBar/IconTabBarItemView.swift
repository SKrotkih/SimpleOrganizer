//
//  IconTabBarItemView.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/31/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class IconTabBarItemView: UIView {
    
    var output: IconTabBarItemInteractorInput!
    @IBOutlet weak var button: UIButton!

    func presentItem(){
        self.output.presentItem()
    }
    
    @IBAction func tabButtonTapped(sender: AnyObject) {
        self.output.selectItem()
    }
}

extension IconTabBarItemView: IconTabBarItemInteractorOutput {

    func redrawItem(data: Dictionary<String, AnyObject>) {
        let select = data["select"] as! Bool
        let rgbHex: UInt32 = select ? 0xF39030 : 0xCCCCCC
        let imageName = data["imagename"] as! String
        let image = UIImage(named: imageName)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.button.setImage(image, forState: .Normal)
            self.backgroundColor = colorWithRGBHex(rgbHex)
        })
    }
    
}