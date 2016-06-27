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

    class var sharedInstance: IconsTabBarConfigurator
    {
        struct Static {
            static var instance: IconsTabBarConfigurator?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = IconsTabBarConfigurator()
        }
        
        return Static.instance!
    }
    
    func configure(viewController: IconsTabBarView)
    {
        let interactor = IconsTabBarInteractor()
        viewController.output = interactor
        
        let presenter = IconsTabBarPresenter()
        interactor.output = presenter

        presenter.output = viewController
    }
    
}
