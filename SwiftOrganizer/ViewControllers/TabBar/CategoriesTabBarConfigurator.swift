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
    class var sharedInstance: CategoriesTabBarConfigurator {
        struct SingletonWrapper {
            static let sharedInstance = CategoriesTabBarConfigurator()
        }
        return SingletonWrapper.sharedInstance;
    }

    private init() {}
    
    func configure(viewController: CategoriesTabBarView)
    {
        let interactor = CategoriesTabBarInteractor()
        let presenter = CategoriesTabBarPresenter()

        interactor.output = presenter
        presenter.output = viewController
        viewController.output = interactor
    }
}
