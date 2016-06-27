//
//  CategoriesTabBarPresenter.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/16/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

class CategoriesTabBarPresenter: CategoriesTabBarInteractorOutput
{
    let tabViewXibName = "CategoryTabBarItemView"
    var output: TabBarPresenterOutput!
    var tabsCache: [CategoryTabBarItemView] = []
    
    func displayTabBarModel(model: [TaskCategory]){
        var tabs: [UIView] = []
        var i: Int = 0
        
        for category: TaskCategory in model {
            if category.visible{
                var tabView: CategoryTabBarItemView
                if i < self.tabsCache.count{
                    tabView = self.tabsCache[i]
                } else {
                    let xibItems: NSArray = NSBundle.mainBundle().loadNibNamed(self.tabViewXibName, owner: nil, options: nil)
                    tabView = xibItems[0] as! CategoryTabBarItemView
                    self.tabsCache.append(tabView)
                }
                CategoryTabBarItemConfigurator.sharedInstance.configure(tabView, category: category)
                tabView.autoresizingMask = UIViewAutoresizing.FlexibleHeight;
                tabView.presentItem()
                tabs.append(tabView)
                i += 1
            }
        }
        output.displayTabs(tabs)
    }
    
}
