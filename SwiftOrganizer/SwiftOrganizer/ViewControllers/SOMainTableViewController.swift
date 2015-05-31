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
    func didSelectCategory(category: Category, select: Bool)
    func didSelectIcon(icon: Ico, select: Bool)
}

class SOMainTableViewController: NSObject, UITableViewDataSource, UITableViewDelegate, SOChangeFilterStateDelegate{

    let tableView : UITableView
    
    var tasks : [SOTask] = []
    
    let mainTableViewCellIdentifier = "MainTableViewCell"
    let mainHeaderTableViewCellIdentifier = "HeaderTableViewCell"
    
    init(tableView aTavleView: UITableView){
        self.tableView = aTavleView
        super.init()
        self.tableView.delegate = self;
        self.tableView.dataSource = self
    }


//    func fetchRequestAllTasks(data: [Task], error: NSErrorPointer) -> Void {
//
//        self.tableView.reloadData()
//    }
//    func getAllTasks(successBlock: (allTaskData: [Task], error: NSErrorPointer) -> Void){
//        SOLocalDataBase.sharedInstance.fetchAllTasks(self.fetchRequestAllTasks)
//    }
    
    func reloadData(){
        SOLocalDataBase.sharedInstance.fetchAllTasks({ (allCurrentTasks: [SOTask], error: NSErrorPointer) in
            self.tasks = allCurrentTasks
            self.tableView.reloadData()
        })
    }
    
    //- MARK: UITableViewDataSource
    /// Number of rows in a section
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count + 1
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            // Header Cell
            var cell = self.tableView.dequeueReusableCellWithIdentifier(mainHeaderTableViewCellIdentifier) as? UITableViewCell
            
            return cell!
        }
        else
        {
            // Task Cell
            var cell = self.tableView.dequeueReusableCellWithIdentifier(mainTableViewCellIdentifier) as? SOMainTableViewCell
            let row = indexPath.row - 1
            let currentTask : SOTask = self.tasks[row]
            cell!.fillTaskData(currentTask)
            
            return cell!
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
        let row = indexPath.row - 1
        let currentTask : SOTask = self.tasks[row]
        let title  = currentTask.title
        let message = "You selected \(title)"
    }
    
    // Customizing the row height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return indexPath.row == 0 ? 28 : 47
    }
    
    
    // - MARK: SOChangeFilterStateDelegate
    
    func didSelectCategory(category: Category, select: Bool){
        SOLocalDataBase.sharedInstance.updateCategory(category, fieldName: "selected", value: select)
        dispatch_async(dispatch_get_main_queue(), {
            self.reloadData()
        })
    }
    
    func didSelectIcon(icon: Ico, select: Bool){
        SOLocalDataBase.sharedInstance.updateIcon(icon, fieldName: "selected", value: select)
        dispatch_async(dispatch_get_main_queue(), {
            self.reloadData()
        })
    }
    
    // - MARK:     
}
