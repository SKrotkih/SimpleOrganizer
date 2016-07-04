//
//  IconsTabBarConfigurator.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/16/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

class IconsTabBarConfigurator
{
    class var sharedInstance: IconsTabBarConfigurator {
        struct SingletonWrapper {
            static let sharedInstance = IconsTabBarConfigurator()
        }
        return SingletonWrapper.sharedInstance;
    }
    
    private init() {}    
    
    func configure(viewController: IconsTabBarView)
    {
        let interactor = IconsTabBarInteractor()
        viewController.output = interactor
        
        let presenter = IconsTabBarPresenter()
        interactor.output = presenter

        presenter.output = viewController
    }
    
}
