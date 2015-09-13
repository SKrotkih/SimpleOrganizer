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
    
    override func reloadTabs(block: (error: NSError?) -> Void){

        SODataSource.sharedInstance.allIcons{(icons: [SOIco], fetchError: NSError?) in
            self.tabsCount = 0

            if let error = fetchError{
                showAlertWithTitle("Error fetching icons data".localized, error.description)
            } else if icons.count > 0{
                
                for i in 0..<icons.count {
                    let ico: SOIco = icons[i]
                    
                    if ico.visible{
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
                        tabView.ico = ico
                        tabView.selected = ico.selected
                        self.tabsCount++
                    }
                }
                super.reloadTabs{(error: NSError?) in
                    block(error: error)
                }
            } else {
                showAlertWithTitle("Warning:", "Icons data are not presented on the Parse.com Server.")
                block(error: nil)
            }
        }
    }
}
