//
//  SOMainTableViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import CoreData


protocol SOChangeFilterStateDelegate{
    func didSelectCategory(category: SOCategory, select: Bool, block: (error: NSError?) -> Void)
    func didSelectIcon(icon: SOIco, select: Bool, block: (error: NSError?) -> Void)
}

class SOMainTableViewController: NSObject, UITableViewDataSource, UITableViewDelegate, SOChangeFilterStateDelegate, SORemoveTaskDelegate{

    let tableView : UITableView
    var taskEditingDelegate: SOEditTaskController?
    
    var tasks : [SOTask] = []
    
    let mainTableViewCellIdentifier = "MainTableViewCell"
    let mainHeaderTableViewCellIdentifier = "HeaderTableViewCell"
    let newRecordTableViewCellIdentifier = "NewRecordTableViewCell"
    
    init(tableView aTavleView: UITableView){
        self.tableView = aTavleView
        super.init()
        self.tableView.delegate = self;
        self.tableView.dataSource = self
    }

    func reloadData(){
        SODataFetching.sharedInstance.fetchAllTasks{(allCurrentTasks: [SOTask], fetchError: NSError?) in
            if let error = fetchError{
                showAlertWithTitle("Error while reading task data!", error.description)
            } else {
                self.tasks = allCurrentTasks
                self.tableView.reloadData()
            }
        }
    }
    
    //- MARK: UITableViewDataSource
    /// Number of rows in a section
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count + 1
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch indexPath.row{
        case 0:
            var cell = self.tableView.dequeueReusableCellWithIdentifier(mainHeaderTableViewCellIdentifier) as! UITableViewCell
            
            return cell
            
        default:
            var cell = self.tableView.dequeueReusableCellWithIdentifier(mainTableViewCellIdentifier) as! SOMainTableViewCell
            let row = indexPath.row - 1
            let currentTask : SOTask = self.tasks[row]
            cell.fillTaskData(currentTask)
            cell.removeTaskDelegate = self
            
            return cell
        }
    }

    //- MARK: UITableViewDelegate
    func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
            return indexPath.row % 4
    }

    // Before the row is selected
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.row == 0 {
            return nil
        } else {
            return indexPath
        }
    }
    
    // After the row is selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row{
        case 0:
            println("Oh headar of the table was pressed!")

        default:
            let row = indexPath.row - 1
            let currentTask : SOTask = self.tasks[row]
            if let delegate = taskEditingDelegate{
                delegate.startEditingTask(currentTask)
            }
        }
    }
    
    // Customizing the row height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return indexPath.row == 0 ? 28 : 47
    }
    
    // - MARK: SOChangeFilterStateDelegate
    func didSelectCategory(category: SOCategory, select: Bool, block: (error: NSError?) -> Void){
        SODataFetching.sharedInstance.updateCategory(category, fieldName: "selected", value: select, block: {(error: NSError?) in
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.reloadData()
                })
            } else {
                showAlertWithTitle("Error saving data", error!.description)
            }
            block(error: error)
        })
    }
    
    func didSelectIcon(icon: SOIco, select: Bool, block: (error: NSError?) -> Void){
        SODataFetching.sharedInstance.updateIcon(icon, fieldName: "selected", value: select, block: {(error: NSError?) in
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.reloadData()
                })
            } else {
                showAlertWithTitle("Error saving data", error!.description)
            }
            block(error: error)
         })
    }
    
    // - MARK: SORemoveTaskDelegate
    func removeTask(task: SOTask!){
        task.remove()
        self.reloadData()
    }
}
