//
//  TaskIconTabView.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/31/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class TaskIconTabView: UIView {
    @IBOutlet weak var button: UIButton!

    var filterStateDelegate: SOChangeFilterStateDelegate?
    var _selected: Bool = false
    var _ico: TaskIco?
    
    var ico: TaskIco? {
        get{
            return _ico
        }
        set{
            _ico = newValue
            if let imageName = newValue?.imageName, let image = UIImage(named: imageName){
                self.button.setImage(image, forState: .Normal)
            }
        }
    }

    var selected: Bool {
        get{
            return _selected
        }
        set{
            _selected = newValue
            let rgbHex: UInt32 = _selected ? 0xF39030 : 0xCCCCCC
            self.backgroundColor = colorWithRGBHex(rgbHex)
        }
    }
    
    @IBAction func tabButtonTapped(sender: AnyObject) {
        if let delegate = self.filterStateDelegate, ico = _ico{
            let newValue: Bool = !self.selected
            delegate.didSelectIcon(ico, select: newValue, completionBlock: {(error: NSError?) in
                if error == nil{
                    ico.selected = newValue
                    self.selected = newValue
                }
            })
        }
    }
}
