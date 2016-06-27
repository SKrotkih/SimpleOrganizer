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

protocol ListTasksRouterInput
{
}

class ListTasksRouter: ListTasksRouterInput
{
  weak var viewController: ListTasksViewController!
  
  // MARK: Communication
  
  func passDataToNextScene(segue: UIStoryboardSegue)
  {
    if segue.identifier == "EditTaskViewController" {
      passDataToEditTaskScene(segue)
    }
  }
  
  func passDataToEditTaskScene(segue: UIStoryboardSegue)
  {
    let editTaskViewController = segue.destinationViewController as! EditTaskViewController
    
    if let selectedIndexPath = viewController.tableView.indexPathForSelectedRow {
        let selectedTask = viewController.tasks[selectedIndexPath.row]
        editTaskViewController.input.taskID = selectedTask.objectID!
    } else {
        editTaskViewController.input.taskID = nil
    }
  }
}
