//
//  SOEditTaskViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

enum SOEditTaskCellId: Int {
    case CategoryCell = 0
    case IconsCell, DateCell, DescriptionCell, Undefined
    func toString() -> String{
        switch self{
        case .CategoryCell:
            return "categoryCell"
        case .IconsCell:
            return "iconsCell"
        case .DateCell:
            return "dateCell"
        case .DescriptionCell:
            return "descriptionCell"
        case .Undefined:
            return "undefinedCell"
        }
    }
}

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
        if let editTask = task{
            editTask.save{(error: NSError?) in
                if let saveError = error{
                    showAlertWithTitle("Update task error".localized, saveError.description)
                } else {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func closeButtonWasPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }


    //- MARK: UITableViewDataSource
    /// Number of rows in a section
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SOEditTaskCellId.Undefined.rawValue
    }
    
    // Customizing the row height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) ->
        CGFloat {
            return 44
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row: SOEditTaskCellId = SOEditTaskCellId(rawValue: indexPath.row)!
        let cellId: String = row.toString()

        switch row{
        case .CategoryCell:
            var cell = self.tableView.dequeueReusableCellWithIdentifier(cellId) as! SOEditTaskCategoryCell
            cell.task = task!
            
            return cell

        case .IconsCell:
            var cell = self.tableView.dequeueReusableCellWithIdentifier(cellId) as! SOEditTaskIconsCell
            cell.task = task!
            
            return cell

        case .DateCell:
            var cell = self.tableView.dequeueReusableCellWithIdentifier(cellId) as! SOEditTaskDateCell
            cell.task = task!
            
            return cell

        case .DescriptionCell:
            var cell = self.tableView.dequeueReusableCellWithIdentifier(cellId) as! SOEditTaskDescriptionCell
            cell.task = task!

            return cell
            
        default:
            assert(false, "Rows is too much!")
            var cell = self.tableView.dequeueReusableCellWithIdentifier(SOEditTaskCellId.Undefined.toString()) as? SOEditTaskCategoryCell
            
            return cell!
        }
    }
    
    //- MARK: UITableViewDelegate
    // After the row is selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)

        let row: SOEditTaskCellId = SOEditTaskCellId(rawValue: indexPath.row)!
        switch row{
        case .CategoryCell:
            let enterCategoryVC = storyboard.instantiateViewControllerWithIdentifier("EnterCategoryVC") as! SOEnterCategoryViewController
            enterCategoryVC.task = task
            self.navigationController!.pushViewController(enterCategoryVC, animated: true)
        case .IconsCell:
            let enterIconsVC = storyboard.instantiateViewControllerWithIdentifier("EnterIconsVC") as! SOEnterIconsViewController
            enterIconsVC.task = task
            self.navigationController!.pushViewController(enterIconsVC, animated: true)
        case .DateCell:
            let enterDateVC = storyboard.instantiateViewControllerWithIdentifier("EnterDateVC") as! SOEnterDateViewController
            enterDateVC.task = task
            enterDateVC.date = task?.date
            self.navigationController!.pushViewController(enterDateVC, animated: true)
        case .DescriptionCell:
            let enterDescrVC = storyboard.instantiateViewControllerWithIdentifier("EnterDescriptionVC") as! SOEnterDescriptionViewController
            enterDescrVC.task = task
            self.navigationController!.pushViewController(enterDescrVC, animated: true)
        default:
            assert(false, "Rows is too much!")
        }
    }
    
    // - MARK:
    
    
}