//
//  TodayViewController.swift
//  Widget
//
//  Created by vandad on 167//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//  Adapted Sergey Krotkih
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import NotificationCenter
import DataBaseKit

class TodayViewController: UIViewController, NCWidgetProviding {
    /* List of items that we want to display in our table view */
    private var tasks = [SOTask]()

    /* The same identifier is saved in our storyboard for the prototype
    cells for this table view controller */
    struct TableViewConstants{
        static let cellIdentifier = "taskcellid"
        static let cellHeight: CGFloat = 32.0
    }
    
    @IBOutlet weak var typeOfDataBaseSwitcher: UISegmentedControl!

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func switchToAnotherDataBase(sender: AnyObject) {
        let index = typeOfDataBaseSwitcher.selectedSegmentIndex
        SOTypeDataBaseSwitcher.switchToIndex(DataBaseIndex(rawValue: index)!)

        let urlAsString = "\(WidgetUrlScheme)://\(KeyInURLAsSwitchDataBase)\(index)"
        let url = NSURL(string: urlAsString)
        self.extensionContext!.openURL(url!, completionHandler: nil)
    }
    
    func resetContentSize(){
        var prefferedSize: CGSize = tableView.contentSize
        prefferedSize.height = CGRectGetMaxY(self.typeOfDataBaseSwitcher.frame)
        prefferedSize.height += 15.0
        prefferedSize.height += CGFloat(self.tasks.count) * TableViewConstants.cellHeight
        
        self.preferredContentSize = prefferedSize
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let index = SOTypeDataBaseSwitcher.currentDataBaseIndex()
        self.typeOfDataBaseSwitcher.selectedSegmentIndex = index.rawValue
        
        self.performFetch()
    }
    
    func performFetch() -> NCUpdateResult {
        SOFetchingData.sharedInstance.allTasks{(allCurrentTasks: [SOTask], fetchError: NSError?) in
            if let error = fetchError{
                print("Error reading tasks data \(error.description)")
                self.tasks.removeAll(keepCapacity: true)
            } else {
                self.tasks = allCurrentTasks
                self.tableView.reloadData()
                self.resetContentSize()
            }
        }
        
        return .NewData
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        let result = performFetch()
        completionHandler(result)
    }
    
}

    // MARK: - UITableViewDelegate, UITableViewDataSource delegate protocol

extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(tableView: UITableView,  heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return TableViewConstants.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewConstants.cellIdentifier, forIndexPath: indexPath) as! SOWidgetTableViewCell
        let row = indexPath.row
        let task: SOTask = self.tasks[row]
        let categoryName = task.categoryName
        let taskDescription = task.title
        cell.categoryLabel!.text = categoryName
        cell.descriptionLabel!.text = taskDescription
        
        if let dateEvent = task.date{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            cell.dateLabel.text = dateFormatter.stringFromDate(dateEvent)
        } else{
            cell.dateLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let task: SOTask = self.tasks[row]
        
        if let taskId = task.taskId{
            let urlAsString = "\(WidgetUrlScheme)://\(KeyInURLAsTaskId)\(taskId)"
            let url = NSURL(string: urlAsString)
            self.extensionContext!.openURL(url!, completionHandler: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
