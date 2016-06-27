//
//  IconTabBarItemConfigurator.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/16/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

class IconTabBarItemConfigurator
{

    class var sharedInstance: IconTabBarItemConfigurator
    {
        struct Static {
            static var instance: IconTabBarItemConfigurator?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = IconTabBarItemConfigurator()
        }
        
        return Static.instance!
    }
    
    func configure(viewController: IconTabBarItemView, ico: TaskIco)
    {
        let interactor = IconTabBarItemInteractor()
        viewController.output = interactor
        interactor.output = viewController
        interactor.icon = ico
    }
    
}
