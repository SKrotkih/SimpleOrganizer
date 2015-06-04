//
//  SOEditTaskViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOEditTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var task: SOTask?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let editTask = task{

        }
        else
        {
            task = SOTask()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let leftButtonImage: UIImage! = UIImage(named: "back_button")
        var leftButton: UIBarButtonItem = UIBarButtonItem(image: leftButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: "closeButtonWasPressed")
        navigationItem.leftBarButtonItem = leftButton;
        
        let rightButtonImage : UIImage! = UIImage(named: "save_task")
        var rightButton: UIBarButtonItem = UIBarButtonItem(image: rightButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonWasPressed")
        navigationItem.rightBarButtonItem = rightButton;
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        
        self.tableView.reloadData()        
    }
    
    func doneButtonWasPressed() {
        self.saveTask()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func closeButtonWasPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func saveTask(){
        if let editTask = task{
            editTask.save()
        }
    }

    //- MARK: UITableViewDataSource
    /// Number of rows in a section
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    // Customizing the row height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) ->
        CGFloat {
            return 44
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let editTaskCategoryCellIdentifier = "categoryCell"
        let editTaskIconsCellIdentifier = "iconsCell"
        let editTaskDateCellIdentifier = "dateCell"
        let editTaskDescriptionCellIdentifier = "descriptionCell"
        
        switch indexPath.row{
        case 0:
            var cell = self.tableView.dequeueReusableCellWithIdentifier(editTaskCategoryCellIdentifier) as! SOEditTaskCategoryCell
            cell.task = task!
            
            return cell

        case 1:
            var cell = self.tableView.dequeueReusableCellWithIdentifier(editTaskIconsCellIdentifier) as! SOEditTaskIconsCell
            cell.task = task!
            
            return cell

        case 2:
            var cell = self.tableView.dequeueReusableCellWithIdentifier(editTaskDateCellIdentifier) as! SOEditTaskDateCell
            cell.task = task!
            
            return cell

        case 3:
            var cell = self.tableView.dequeueReusableCellWithIdentifier(editTaskDescriptionCellIdentifier) as! SOEditTaskDescriptionCell
            cell.task = task!

            return cell
            
        default:
            assert(false, "Rows is too much!")
            var cell = self.tableView.dequeueReusableCellWithIdentifier(editTaskCategoryCellIdentifier) as? SOEditTaskCategoryCell
            
            return cell!
        }
    }
    
    //- MARK: UITableViewDelegate
    // After the row is selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch indexPath.row{
        case 0:
            let enterCategoryVC = storyboard.instantiateViewControllerWithIdentifier("EnterCategoryVC") as! SOEnterCategoryViewController
            enterCategoryVC.task = task
            self.navigationController!.pushViewController(enterCategoryVC, animated: true)
        case 1:
            let enterIconsVC = storyboard.instantiateViewControllerWithIdentifier("EnterIconsVC") as! SOEnterIconsViewController
            enterIconsVC.task = task
            self.navigationController!.pushViewController(enterIconsVC, animated: true)
        case 2:
            let enterDateVC = storyboard.instantiateViewControllerWithIdentifier("EnterDateVC") as! SOEnterDateViewController
            enterDateVC.task = task
            self.navigationController!.pushViewController(enterDateVC, animated: true)
        case 3:
            let enterDescrVC = storyboard.instantiateViewControllerWithIdentifier("EnterDescriptionVC") as! SOEnterDescriptionViewController
            enterDescrVC.task = task
            self.navigationController!.pushViewController(enterDescrVC, animated: true)
        default:
                println("")
        }
    }
    
    // - MARK:
    
    
}