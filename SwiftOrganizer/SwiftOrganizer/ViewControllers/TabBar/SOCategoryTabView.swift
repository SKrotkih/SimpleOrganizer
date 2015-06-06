//
//  SOCategoryTabView.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/31/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOCategoryTabView: UIView {

    var filterStateDelegate: SOChangeFilterStateDelegate?

    var _selected: Bool = false
    
    var _category: Category?
    
    var category: Category? {
        get{
            return _category
        }
        set{
            _category = newValue
            self.button.setTitle( newValue?.name, forState: .Normal)
        }
    }
    
    @IBOutlet weak var button: UIButton!
    
    var selected: Bool {
        get{
            return _selected
        }
        set{
            _selected = newValue
            
            if _selected == true{
                self.backgroundColor = colorWithRGBHex(0xC0C0C0)
            }
            else
            {
                self.backgroundColor = colorWithRGBHex(0xCCCCCC)
            }
        }
    }
    
    @IBAction func buttonPressedHandler(sender: AnyObject) {
        if let delegate = self.filterStateDelegate, category = _category{
            self.selected = !self.selected
            delegate.didSelectCategory(category, select: self.selected)
        }
    }

}