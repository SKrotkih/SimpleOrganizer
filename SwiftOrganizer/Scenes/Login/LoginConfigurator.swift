//
//  LoginConfigurator.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/12/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import UIKit
import DataBaseKit

extension LoginInteractor: LoginViewControllerOutput
{
}

class LoginConfigurator
{
    class var sharedInstance: LoginConfigurator {
        struct SingletonWrapper {
            static let sharedInstance = LoginConfigurator()
        }
        
        return SingletonWrapper.sharedInstance;
    }
    
    // MARK: Configuration
    
    func configure(viewController: LoginViewController)
    {
        let router = LoginRouter()
        router.viewController = viewController
        
        let presenter = LoginPresenter()
        presenter.output = viewController
        
        let interactor = LoginInteractor()
        interactor.output = presenter
        interactor.viewController = viewController  // only as the login screen superview
        
        viewController.output = interactor
        viewController.router = router
    }
}

