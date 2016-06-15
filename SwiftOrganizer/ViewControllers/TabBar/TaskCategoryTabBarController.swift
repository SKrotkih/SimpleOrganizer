//
//  TaskCategoryTabBarController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/31/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class TaskCategoryTabBarController: SOTabBarController {

    private let tabViewXibName = "TaskCategoryTabView"
    
    override func reloadTabs(completionBlock: (error: NSError?) -> Void){
        SOFetchingData.sharedInstance.allCategories{(categories: [TaskCategory], fetchError: NSError?) in
            self.tabsCount = 0
            
            if let error = fetchError{
                showAlertWithTitle("Failed to read of categories data".localized, message: error.localizedDescription)
                return
            }
            if categories.count > 0{
                for i in 0..<categories.count {
                    let category: TaskCategory = categories[i]
                    
                    if category.visible{
                        var tabView: TaskCategoryTabView!
                        
                        if i < self.tabs.count{
                            tabView = self.tabs[i] as! TaskCategoryTabView
                        } else {
                            let xibItems: NSArray = NSBundle.mainBundle().loadNibNamed(self.tabViewXibName, owner: nil, options: nil)
                            tabView = xibItems[0] as! TaskCategoryTabView
                            tabView.autoresizingMask = UIViewAutoresizing.FlexibleHeight;
                            tabView.filterStateDelegate = self.filterStateDelegate
                            self.tabs.append(tabView)
                        }
                        tabView.category = category
                        tabView.selected = category.selected
                        self.tabsCount += 1
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
