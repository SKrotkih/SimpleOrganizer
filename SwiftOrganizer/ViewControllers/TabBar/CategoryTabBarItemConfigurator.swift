//
//  CategoryTabBarItemConfigurator.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/16/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

class CategoryTabBarItemConfigurator
{

    class var sharedInstance: CategoryTabBarItemConfigurator
    {
        struct Static {
            static var instance: CategoryTabBarItemConfigurator?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = CategoryTabBarItemConfigurator()
        }
        
        return Static.instance!
    }
    
    func configure(viewController: CategoryTabBarItemView, category: TaskCategory)
    {
        let interactor = CategoryTabBarItemInteractor()
        viewController.output = interactor
        interactor.output = viewController
        interactor.category = category
    }
    
}
