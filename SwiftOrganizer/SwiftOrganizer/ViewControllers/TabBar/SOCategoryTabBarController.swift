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
    
    override func reloadTabs(successBlock: (error: NSError?) -> Void){
        SODataFetching.sharedInstance.allCategories{(categories: [SOCategory], fetchError: NSError?) in
            self.tabsCount = 0
            
            if let error = fetchError{
                showAlertWithTitle("Error reading categories data", error.description)
            } else if categories.count > 0{
                self.tabsCount = categories.count

                for i in 0..<self.tabsCount {
                    var tabView: SOCategoryTabView!
                    
                    if i < self.tabs.count{
                        tabView = self.tabs[i] as! SOCategoryTabView
                    } else {
                        var xibItems: NSArray = NSBundle.mainBundle().loadNibNamed(self.tabViewXibName, owner: nil, options: nil)
                        tabView = xibItems[0] as! SOCategoryTabView
                        tabView.autoresizingMask = UIViewAutoresizing.FlexibleHeight;                        
                        tabView.filterStateDelegate = self.filterStateDelegate
                        self.tabs.append(tabView)
                    }
                    
                    let category: SOCategory = categories[i]
                    tabView.category = category
                    tabView.selected = category.selected
                }
                super.reloadTabs{(error: NSError?) in
                    successBlock(error: error)
                }
            } else {
                showAlertWithTitle("Warning:", "Categories data are not presented on the Parse.com Server.")
                successBlock(error: nil)
            }
        }
    }
}
