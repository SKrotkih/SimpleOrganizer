//
//  TaskIconsTabBarController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/31/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class TaskIconsTabBarController: SOTabBarController {

    let tabViewXibName = "TaskIconTabView"
    
    override func reloadTabs(block: (error: NSError?) -> Void){

        SOFetchingData.sharedInstance.allIcons{(icons: [TaskIco], fetchError: NSError?) in
            self.tabsCount = 0

            if let error = fetchError{
                showAlertWithTitle("Error fetching icons data".localized, message: error.description)
            } else if icons.count > 0{
                
                for i in 0..<icons.count {
                    let ico: TaskIco = icons[i]
                    
                    if ico.visible{
                        var tabView: TaskIconTabView!
                        
                        if i < self.tabs.count{
                            tabView = self.tabs[i] as! TaskIconTabView
                        } else {
                            let xibItems: NSArray = NSBundle.mainBundle().loadNibNamed(self.tabViewXibName, owner: nil, options: nil)
                            tabView = xibItems[0] as! TaskIconTabView
                            tabView.autoresizingMask = UIViewAutoresizing.FlexibleHeight;
                            tabView.filterStateDelegate = self.filterStateDelegate
                            self.tabs.append(tabView)
                        }
                        tabView.ico = ico
                        tabView.selected = ico.selected
                        self.tabsCount += 1
                    }
                }
                super.reloadTabs{(error: NSError?) in
                    block(error: error)
                }
            } else {
                showAlertWithTitle("Warning:", message: "Icons data are not presented on the Parse.com Server.")
                block(error: nil)
            }
        }
    }
}
