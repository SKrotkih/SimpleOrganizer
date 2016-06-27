//
//  IconsTabBarPresenter.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/16/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

protocol TabBarPresenterOutput {
    func displayTabs(tabs: [UIView])
}

class IconsTabBarPresenter: IconsTabBarInteractorOutput
{
    let tabViewXibName = "IconTabBarItemView"
    var output: TabBarPresenterOutput!
    var tabsCache: [IconTabBarItemView] = []
    
    func displayTabBarModel(model: [TaskIco]){
        var tabs: [UIView] = []
        var i: Int = 0
        for ico: TaskIco in model {
            if ico.visible{
                var tabView: IconTabBarItemView
                if i < self.tabsCache.count{
                    tabView = self.tabsCache[i]
                } else {
                    let xibItems: NSArray = NSBundle.mainBundle().loadNibNamed(self.tabViewXibName, owner: nil, options: nil)
                    tabView = xibItems[0] as! IconTabBarItemView
                    self.tabsCache.append(tabView)
                }
                IconTabBarItemConfigurator.sharedInstance.configure(tabView, ico: ico)
                tabView.autoresizingMask = UIViewAutoresizing.FlexibleHeight;
                tabView.presentItem()
                tabs.append(tabView)
                i += 1
            }
        }
        output.displayTabs(tabs)
    }
    
}
