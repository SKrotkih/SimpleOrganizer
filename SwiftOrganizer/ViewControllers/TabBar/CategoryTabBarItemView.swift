//
//  CategoryTabBarItemView.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/31/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class CategoryTabBarItemView: UIView {
    var output: CategoryTabBarItemInteractorInput!
    
    @IBOutlet weak var tabBackgroundView: UIView!
    @IBOutlet weak var button: UIButton!

    func presentItem(){
        self.output.presentItem()
    }
    
    @IBAction func tabButtonTapped(sender: AnyObject) {
        self.output.selectItem()
    }
}

extension CategoryTabBarItemView: CategoryTabBarItemInteractorOutput {
    
    func redrawItem(data: Dictionary<String, AnyObject>) {
        let select = data["select"] as! Bool
        let rgbHex: UInt32 = select ? 0xF39030 : 0xCCCCCC
        let name = data["name"] as! String
        
        dispatch_async(dispatch_get_main_queue(), {
            self.button.setTitle(name, forState: .Normal)
            self.tabBackgroundView.backgroundColor = colorWithRGBHex(rgbHex)
        })
    }
    
}