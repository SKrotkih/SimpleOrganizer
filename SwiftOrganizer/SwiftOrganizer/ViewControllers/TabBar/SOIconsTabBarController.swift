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
        
        let allIcons: [SOIco] = SODataFetching.sharedInstance.allIcons
        self.tabsCount = allIcons.count
        
        if self.tabsCount > 0{
            
            while tabs.count < self.tabsCount{
                var xibItems: NSArray = NSBundle.mainBundle().loadNibNamed(tabViewXibName, owner: nil, options: nil)
                let tabView: SOIconTabView = xibItems[0] as! SOIconTabView
                tabs.append(tabView)
            }
            
            for var i = 0; i < self.tabsCount; i++ {
                let ico: SOIco = allIcons[i]
                let tabView: SOIconTabView = tabs[i] as! SOIconTabView
                tabView.filterStateDelegate = self.filterStateDelegate                
                tabView.ico = ico
                tabView.selected = ico.selected
            }
        }
        
        super.reloadTabs()
    }
}
