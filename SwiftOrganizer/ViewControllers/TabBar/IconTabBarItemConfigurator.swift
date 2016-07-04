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
    class var sharedInstance: IconTabBarItemConfigurator {
        struct SingletonWrapper {
            static let sharedInstance = IconTabBarItemConfigurator()
        }
        return SingletonWrapper.sharedInstance;
    }
    
    private init() {}    
    
    func configure(viewController: IconTabBarItemView, ico: TaskIco)
    {
        let interactor = IconTabBarItemInteractor()
        viewController.output = interactor
        interactor.output = viewController
        interactor.icon = ico
    }
    
}
