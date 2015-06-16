//
//  SOCategoryTabBarController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/31/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOCategoryTabBarController: SOTabBarController {

    let tabViewXibName = "SOCategoryTabView"
    
    override func reloadTabs(){

        let allCategories: [SOCategory] = SODataFetching.sharedInstance.allCategories
        self.tabsCount = allCategories.count

        if self.tabsCount > 0{
            
            while tabs.count < self.tabsCount{
                var xibItems: NSArray = NSBundle.mainBundle().loadNibNamed(tabViewXibName, owner: nil, options: nil)
                let tabView: SOCategoryTabView = xibItems[0] as! SOCategoryTabView
                tabs.append(tabView)
            }
            
            for var i = 0; i < self.tabsCount; i++ {
                let category: SOCategory = allCategories[i]
                let tabView: SOCategoryTabView = tabs[i] as! SOCategoryTabView
                tabView.filterStateDelegate = self.filterStateDelegate
                tabView.category = category
                tabView.selected = category.selected
            }
        }
        
        super.reloadTabs()
    }
}
