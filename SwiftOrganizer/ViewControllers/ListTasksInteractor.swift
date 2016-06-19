//
//  ListTasksInteractor.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/17/16.
//  Copyright (c) 2016 Sergey Krotkih. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol ListTasksInteractorInput
{
    func fetchTasks()
    func selectCategory(category: TaskCategory, select: Bool, completionBlock: (error: NSError?) -> Void)
    func selectIcon(icon: TaskIco, select: Bool, completionBlock: (error: NSError?) -> Void)
    func removeTask(task: ListTasks.FetchTasks.ViewModel.DisplayedTask)
}

protocol ListTasksInteractorOutput
{
    func presentFetchedTasks(response: ListTasks.FetchTasks.Response)
}

class ListTasksInteractor: ListTasksInteractorInput
{
    var output: ListTasksInteractorOutput!
    var tasksWorker: ListTasksWorker!
    var viewController: UIViewController?
    var tasks: [Task]?
    
    func fetchTasks(){
        SOFetchingData.sharedInstance.allTasks{[weak self](tasks: [Task], fetchError: NSError?) in
            if let error = fetchError{
                self?.showAlertWithTitle("Failed to fetch data!".localized, message: error.localizedDescription, addActions: nil, completionBlock: {
                })
            } else {
                self?.tasks = tasks
                let response = ListTasks.FetchTasks.Response(tasks: tasks)
                self?.output.presentFetchedTasks(response)
                self?.addTasksToReminder(tasks)
            }
        }
    }
    
    private func addTasksToReminder(tasks: [Task]){
        
        SOLocalNotificationsCenter.cancelAllNotifications()
        
        for task: Task in tasks{
            if let date = task.date{
                if date.compare(NSDate()) == NSComparisonResult.OrderedDescending{
                    let userInfo: [NSObject : AnyObject] = [
                        SOLocalNotificationsCenter.kTaskIdKeyName(): self.forReminderMessageTask(task, date: date)
                    ]
                    SOLocalNotificationsCenter.sendScheduleNotification(task.title, date: date, userInfo: userInfo)
                }
            }
        }
    }
    
    private func forReminderMessageTask(task: Task, date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let  message = "\(task.categoryName):\n\(task.title)\nat \(dateFormatter.stringFromDate(date))"
        
        return message
    }
    
    func selectCategory(category: TaskCategory, select: Bool, completionBlock: (error: NSError?) -> Void){
        category.setSelected(select, completionBlock: {[weak self] (error) -> Void in
            if error == nil {
                self?.fetchTasks()
                dispatch_async(dispatch_get_main_queue(), {
                    completionBlock(error: nil)
                })
            } else {
                self?.showAlertWithTitle("Error of saving data".localized, message: error!.localizedDescription, addActions: nil, completionBlock: {
                    completionBlock(error: error)
                })
            }
            })
    }
    
    func selectIcon(icon: TaskIco, select: Bool, completionBlock: (error: NSError?) -> Void){
        icon.setSelected(select, completionBlock: {[weak self] (error) -> Void in
            if error == nil {
                self?.fetchTasks()
                dispatch_async(dispatch_get_main_queue(), {
                    completionBlock(error: nil)
                    })
            } else {
                self?.showAlertWithTitle("Error of saving data".localized, message: error!.localizedDescription, addActions: nil, completionBlock: {
                    completionBlock(error: error)
                })
            }
            })
    }
    
    func removeTask(task: ListTasks.FetchTasks.ViewModel.DisplayedTask){
        if let taskID =  task.objectID{
            SODataBaseFactory.sharedInstance.dataBase.removeTask(taskID)
        }
    }
    
}

extension ListTasksInteractor{
    func showAlertWithTitle(title: String, message: String, addActions: ((controller: UIAlertController) -> Void)?, completionBlock: (() -> Void)?){
        let controller = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        if addActions != nil {
            addActions!(controller: controller)
        } else {
            controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        }
        viewController?.presentViewController(controller, animated: true, completion: completionBlock)
    }
}
