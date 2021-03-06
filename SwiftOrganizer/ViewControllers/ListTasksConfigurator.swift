//
//  ListTasksConfigurator.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/17/16.
//  Copyright (c) 2016 Sergey Krotkih. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

extension ListTasksPresenter: ListTasksInteractorOutput
{
}

class ListTasksConfigurator
{
    class var sharedInstance: ListTasksConfigurator {
        struct SingletonWrapper {
            static let sharedInstance = ListTasksConfigurator()
        }
        return SingletonWrapper.sharedInstance;
    }

    private init() {
    }
    
    func configure(viewController: ListTasksViewController)
    {
        let router = ListTasksRouter()
        router.viewController = viewController
        
        let presenter = ListTasksPresenter()
        presenter.output = viewController
        
        let interactor = ListTasksInteractor()
        interactor.output = presenter
        
        viewController.output = interactor
        viewController.router = router
    }
}
