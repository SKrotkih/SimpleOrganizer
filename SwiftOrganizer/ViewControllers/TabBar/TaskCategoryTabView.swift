//
//  TaskCategoryTabView.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/31/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class TaskCategoryTabView: UIView {
    @IBOutlet weak var tabBackgroundView: UIView!
    @IBOutlet weak var button: UIButton!
    
    var filterStateDelegate: SOChangeFilterStateDelegate?
    var _selected: Bool = false
    var _category: TaskCategory?
    
    var category: TaskCategory? {
        get{
            return _category
        }
        set{
            _category = newValue
            self.button.setTitle( _category?.name, forState: .Normal)
        }
    }
    
    var selected: Bool {
        get{
            return _selected
        }
        set{
            _selected = newValue
            let rgbHex: UInt32 = _selected ? 0xF39030 : 0xCCCCCC
            self.tabBackgroundView.backgroundColor = colorWithRGBHex(rgbHex)
        }
    }
    
    @IBAction func tabButtonTapped(sender: AnyObject) {
        guard let delegate = self.filterStateDelegate, category = self.category else{
            return
        }

        let newValue: Bool = !self.selected
        delegate.didSelectCategory(category, select: newValue, completionBlock: {(error: NSError?) in
            if error == nil{
                category.selected = newValue
                self.selected = newValue
            }
        })
    }

}