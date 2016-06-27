//
//  CategoriesTabBarConfigurator.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/16/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

class CategoriesTabBarConfigurator
{
    
    class var sharedInstance: CategoriesTabBarConfigurator
    {
        struct Static {
            static var instance: CategoriesTabBarConfigurator?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = CategoriesTabBarConfigurator()
        }
        
        return Static.instance!
    }
    
    func configure(viewController: CategoriesTabBarView)
    {
        let interactor = CategoriesTabBarInteractor()
        viewController.output = interactor
        
        let presenter = CategoriesTabBarPresenter()
        interactor.output = presenter
        
        presenter.output = viewController
    }
}
