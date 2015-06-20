//
//  SOIconsTabBarController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/31/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOIconsTabBarController: SOTabBarController {

    let tabViewXibName = "SOIconTabView"
    
    override func reloadTabs(successBlock: (error: NSError?) -> Void){

        SODataFetching.sharedInstance.allIcons{(icons: [SOIco], fetchError: NSError?) in
            self.tabsCount = 0

            if let error = fetchError{
                showAlertWithTitle("Error reading icons data", error.description)
            } else if icons.count > 0{
                self.tabsCount = icons.count
                
                for i in 0..<self.tabsCount {
                    var tabView: SOIconTabView!
                    
                    if i < self.tabs.count{
                        tabView = self.tabs[i] as! SOIconTabView
                    } else {
                        var xibItems: NSArray = NSBundle.mainBundle().loadNibNamed(self.tabViewXibName, owner: nil, options: nil)
                        tabView = xibItems[0] as! SOIconTabView
                        tabView.autoresizingMask = UIViewAutoresizing.FlexibleHeight;
                        tabView.filterStateDelegate = self.filterStateDelegate
                        self.tabs.append(tabView)                        
                    }
                    let ico: SOIco = icons[i]
                    tabView.ico = ico
                    tabView.selected = ico.selected
                }
                super.reloadTabs{(error: NSError?) in
                    successBlock(error: error)
                }
            } else {
                showAlertWithTitle("Warning:", "Icons data are not presented on the Parse.com Server.")
                successBlock(error: nil)
            }
        }
    }
}
