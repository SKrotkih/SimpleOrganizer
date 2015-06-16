//
//  SOIconTabView.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/31/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOIconTabView: UIView {

    var filterStateDelegate: SOChangeFilterStateDelegate?
    
    var _selected: Bool = false
    
    var _ico: SOIco?
    
    var ico: SOIco? {
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
            
            if _selected == true{
                self.backgroundColor = colorWithRGBHex(0xF39030)
            }
            else
            {
                self.backgroundColor = colorWithRGBHex(0xCCCCCC)
            }
        }
    }
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonPressedHandler(sender: AnyObject) {
        if let delegate = self.filterStateDelegate, ico = _ico{
            self.selected = !self.selected
            delegate.didSelectIcon(ico, select: self.selected)
        }
    }
}
