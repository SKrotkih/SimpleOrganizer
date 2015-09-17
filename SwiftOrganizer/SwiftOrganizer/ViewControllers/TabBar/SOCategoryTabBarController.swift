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
    
    override func reloadTabs(completionBlock: (error: NSError?) -> Void){
        SOFetchingData.sharedInstance.allCategories{(categories: [SOCategory], fetchError: NSError?) in
            self.tabsCount = 0
            
            if let error = fetchError{
                showAlertWithTitle("Failed to read of categories data".localized, message: error.description)
            } else if categories.count > 0{
                for i in 0..<categories.count {
                    let category: SOCategory = categories[i]
                    
                    if category.visible{
                        var tabView: SOCategoryTabView!
                        
                        if i < self.tabs.count{
                            tabView = self.tabs[i] as! SOCategoryTabView
                        } else {
                            let xibItems: NSArray = NSBundle.mainBundle().loadNibNamed(self.tabViewXibName, owner: nil, options: nil)
                            tabView = xibItems[0] as! SOCategoryTabView
                            tabView.autoresizingMask = UIViewAutoresizing.FlexibleHeight;
                            tabView.filterStateDelegate = self.filterStateDelegate
                            self.tabs.append(tabView)
                        }
                        tabView.category = category
                        tabView.selected = category.selected
                        self.tabsCount++
                    }
                }
                super.reloadTabs{(error: NSError?) in
                    completionBlock(error: error)
                }
            } else {
                showAlertWithTitle("Warning".localized, message: "Categories data are not presented on the Parse.com Server.".localized)
                completionBlock(error: nil)
            }
        }
    }
}
