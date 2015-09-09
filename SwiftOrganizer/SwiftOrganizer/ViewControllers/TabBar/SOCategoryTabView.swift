//
//  SOCategoryTabView.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/31/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOCategoryTabView: UIView {
    @IBOutlet weak var tabBackgroundView: UIView!
    @IBOutlet weak var button: UIButton!
    
    var filterStateDelegate: SOChangeFilterStateDelegate?
    var _selected: Bool = false
    var _category: SOCategory?
    
    var category: SOCategory? {
        get{
            return _category
        }
        set{
            _category = newValue
            self.button.setTitle( newValue?.name, forState: .Normal)
        }
    }
    
    var selected: Bool {
        get{
            return _selected
        }
        set{
            _selected = newValue
            
            if _selected == true{
                self.tabBackgroundView.backgroundColor = colorWithRGBHex(0xF39030)
            }
            else
            {
                self.tabBackgroundView.backgroundColor = colorWithRGBHex(0xCCCCCC)
            }
        }
    }
    
    @IBAction func buttonPressedHandler(sender: AnyObject) {
        if let delegate = self.filterStateDelegate, category = _category{
            let newValue: Bool = !self.selected
            delegate.didSelectCategory(category, select: newValue, completionBlock: {(error: NSError?) in
                if error == nil{
                    category.selected = newValue
                    self.selected = newValue
                }
            })
        }
    }

}