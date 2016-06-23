//
//  ListTasksRouter.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/17/16.
//  Copyright (c) 2016 Sergey Krotkih. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

class EditTaskRouter
{
    weak var viewController: EditTaskViewController!
    
    // MARK: Communication
    
    func passDataToNextScene(segue: UIStoryboardSegue)
    {
        let editTaskDetailsViewController = segue.destinationViewController as! EditTaskDetailViewController
        editTaskDetailsViewController.undoDelegate = viewController
        editTaskDetailsViewController.input = viewController.input.responce
    }
}
