//
//  SOCategoryTabBarController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/31/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOCategoryTabBarController: SOTabBarController {

    private let tabViewXibName = "SOCategoryTabView"
    
    override func reloadTabs(){
        SODataFetching.sharedInstance.allCategories{(categories: [SOCategory], fetchError: NSError?) in
            if let error = fetchError{
                showAlertWithTitle("Error reading categories data", error.description)
            } else if categories.count > 0{
                self.tabsCount = categories.count
                
                if self.tabsCount > 0{
                    
                    while self.tabs.count < self.tabsCount{
                        var xibItems: NSArray = NSBundle.mainBundle().loadNibNamed(self.tabViewXibName, owner: nil, options: nil)
                        let tabView: SOCategoryTabView = xibItems[0] as! SOCategoryTabView
                        self.tabs.append(tabView)
                    }
                    
                    for var i = 0; i < self.tabsCount; i++ {
                        let category: SOCategory = categories[i]
                        let tabView: SOCategoryTabView = self.tabs[i] as! SOCategoryTabView
                        tabView.filterStateDelegate = self.filterStateDelegate
                        tabView.category = category
                        tabView.selected = category.selected
                    }
                }
                
                super.reloadTabs()
            } else {
                showAlertWithTitle("Warning!", "Categories data are not presented on the Parse.com Server.")
            }
        }
    }
}
