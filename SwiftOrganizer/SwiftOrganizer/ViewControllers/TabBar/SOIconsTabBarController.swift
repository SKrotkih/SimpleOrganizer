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
    
    override func reloadTabs(){

        SODataFetching.sharedInstance.allIcons{(icons: [SOIco], fetchError: NSError?) in
            if let error = fetchError{
                showAlertWithTitle("Error reading icons data", error.description)
            } else if icons.count > 0{
                self.tabsCount = icons.count
                
                if self.tabsCount > 0{
                    
                    while self.tabs.count < self.tabsCount{
                        var xibItems: NSArray = NSBundle.mainBundle().loadNibNamed(self.tabViewXibName, owner: nil, options: nil)
                        let tabView: SOIconTabView = xibItems[0] as! SOIconTabView
                        self.tabs.append(tabView)
                    }
                    
                    for var i = 0; i < self.tabsCount; i++ {
                        let ico: SOIco = icons[i]
                        let tabView: SOIconTabView = self.tabs[i] as! SOIconTabView
                        tabView.filterStateDelegate = self.filterStateDelegate
                        tabView.ico = ico
                        tabView.selected = ico.selected
                    }
                }
                
                super.reloadTabs()
            } else {
                showAlertWithTitle("Warning!", "Icons data are not presented on the Parse.com Server.")
            }
        }
    }
}
