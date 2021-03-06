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
    func removeTask(task: ListTasks.FetchTasks.ViewModel.DisplayedTask)
}

protocol ListTasksInteractorOutput
{
    func presentFetchedTasks(response: ListTasks.FetchTasks.Response)
}

class ListTasksInteractor: ListTasksInteractorInput
{
    var output: ListTasksInteractorOutput!
    var tasks: [Task]!
    
    func fetchTasks(){
        SOFetchingData.sharedInstance.allTasks{[weak self](tasks: [Task], fetchError: NSError?) in
            if let error = fetchError{
                showAlertWithTitle("Failed to fetch tasks data!".localized, message: error.localizedDescription)
            } else {
                SODataBaseFactory.sharedInstance.dataBase.allCategories{(categories: [TaskCategory], error: NSError?) in
                    if let _error = error{
                        showAlertWithTitle("Failed to fetch categories data!".localized, message: _error.localizedDescription)
                    } else {
                        SODataBaseFactory.sharedInstance.dataBase.allIcons{(icons: [TaskIco], error: NSError?) in
                            if let _error = error {
                                showAlertWithTitle("Failed to fetch icons data!".localized, message: _error.localizedDescription)
                            } else {
                                let iconsCriteria: FilterTasksByIcons = FilterTasksByIcons(icons)
                                let categoriesCriteria: FilterTasksByCategories = FilterTasksByCategories(categories)
                                let iconsAndCategories: FilterTasksANDcriteria = FilterTasksANDcriteria(iconsCriteria, categoriesCriteria)
                                self?.tasks = iconsAndCategories.meetCriteria(tasks)
                                let response = ListTasks.FetchTasks.Response(tasks: (self?.tasks)!)
                                self?.output.presentFetchedTasks(response)
                                self?.addTasksToReminder((self?.tasks)!)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func removeTask(task: ListTasks.FetchTasks.ViewModel.DisplayedTask){
        if let taskID = task.objectID{
            SODataBaseFactory.sharedInstance.dataBase.removeTask(taskID)
        }
    }
}

extension ListTasksInteractor {
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
}
