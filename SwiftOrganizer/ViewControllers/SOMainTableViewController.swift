//
//  SOMainTableViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

protocol SOChangeFilterStateDelegate{
    func didSelectCategory(category: TaskCategory, select: Bool, completionBlock: (error: NSError?) -> Void)
    func didSelectIcon(icon: TaskIco, select: Bool, completionBlock: (error: NSError?) -> Void)
}

class SOMainTableViewController: NSObject{

    let tableView : UITableView
    var taskEditingDelegate: SOEditTaskController
    
    var tasks : [Task] = []
    
    init(tableView aTavleView: UITableView, delegate: SOEditTaskController){
        self.tableView = aTavleView
        self.taskEditingDelegate = delegate
        
        super.init()
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self
    }

    func reloadData(){
        SOFetchingData.sharedInstance.allTasks{(allCurrentTasks: [Task], fetchError: NSError?) in
            if let error = fetchError{
                showAlertWithTitle("Failed to fetch data!".localized, message: error.localizedDescription)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tasks = allCurrentTasks
                self.addTasksToReminder(self.tasks)
                self.tableView.reloadData()
            })
        }
    }
    
    func addTasksToReminder(tasks: [Task]){

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

    // MARK: SOChangeFilterStateDelegate

extension SOMainTableViewController: SOChangeFilterStateDelegate{

    func didSelectCategory(category: TaskCategory, select: Bool, completionBlock: (error: NSError?) -> Void){
        category.setSelected(select, completionBlock: { (error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.reloadData()
                })
            } else {
                showAlertWithTitle("Error of saving data".localized, message: error!.description)
            }
            completionBlock(error: error)
        })
    }
    
    func didSelectIcon(icon: TaskIco, select: Bool, completionBlock: (error: NSError?) -> Void){
        icon.setSelected(select, completionBlock: { (error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), {[weak self] in
                    self?.reloadData()
                })
            } else {
                showAlertWithTitle("Error of saving data".localized, message: error!.description)
            }
            completionBlock(error: error)
        })
    }
}

    // MARK: SORemoveTaskDelegate

extension SOMainTableViewController: SORemoveTaskDelegate{
    func removeTask(task: Task!){
        self.taskEditingDelegate.editTaskList()
    }
}

    // MARK: UITableViewDataSource

extension SOMainTableViewController: UITableViewDataSource {

    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(self.mainTableViewCellIdentifier()) as! SOMainTableViewCell
        let row = indexPath.row
        let currentTask : Task = self.tasks[row]
        cell.fillTaskData(currentTask)
        cell.removeTaskDelegate = self
        
        return cell
    }
}

    // MARK: UITableViewDelegate

extension SOMainTableViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        return indexPath.row % 4
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if (self.tableView.editing) {
            return .Delete
        }
        
        return .None
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            self.tableView.beginUpdates()
            let row = indexPath.row
            let currentTask : Task = self.tasks[row]
            currentTask.remove()
            self.tasks.removeAtIndex(row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.tableView.endUpdates()
        }
    }
    
    // Before the row is selected
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath
    }
    
    // After the row is selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let currentTask : Task = self.tasks[row]
        self.taskEditingDelegate.startEditingTask(currentTask)
    }
    
    // Customizing the row height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.heightOfTableRow()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        switch section {
        case 0:
            return self.heightOfTableHeader()
        default:
            return 0.0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let headerCell = self.tableView.dequeueReusableCellWithIdentifier(mainHeaderTableViewCellIdentifier())
        
        return headerCell
    }
}

    // MARK: Constants

extension SOMainTableViewController{
    private func mainTableViewCellIdentifier() -> String{
        return "MainTableViewCell"
    }

    private func mainHeaderTableViewCellIdentifier() -> String{
        return "HeaderTableViewCell"
    }
    
    private func heightOfTableRow() -> CGFloat{
        return 47.0
    }
    
    private func heightOfTableHeader() -> CGFloat{
        return 28.0
    }
    
    
}

