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
    class var sharedInstance: CategoryTabBarItemConfigurator {
        struct SingletonWrapper {
            static let sharedInstance = CategoryTabBarItemConfigurator()
        }
        return SingletonWrapper.sharedInstance;
    }

    func configure(viewController: CategoryTabBarItemView, category: TaskCategory)
    {
        let interactor = CategoryTabBarItemInteractor()
        viewController.output = interactor
        interactor.output = viewController
        interactor.category = category
    }
    
}
