//
//  SOEditTaskViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

enum SOEditTaskViewControllerId: String {
    case Category = "EnterCategoryVC"
    case Icons = "EnterIconsVC"
    case Date = "EnterDateVC"
    case Description = "EnterDescriptionVC"
}

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

    private var _task: SOTask
    private var _orgTask: SOTask?
    private var isItNewTask: Bool
    
    @IBOutlet weak var tableView: UITableView!

    required init(coder aDecoder: NSCoder) {
        _task = SOTask()
        isItNewTask = true
        
        super.init(coder: aDecoder)
    }
    
    var task: SOTask?{
        get{
          return _task
        }
        set{
            isItNewTask = (newValue == nil)
            
            if isItNewTask{
                _task.clearTask()
            } else {
                self._orgTask = newValue
                _task.cloneTask(newValue!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.buildObject()
    }
    
    func closeButtonWasPressed() {
        if dataWasChanged() {

            let controller = UIAlertController(title: "Data was chenged!".localized, message: nil, preferredStyle: .ActionSheet)
            let skeepDateAction = UIAlertAction(title: "Close".localized, style: .Cancel, handler: { action in
                self.closeWindow()
            })
            let saveDateAction = UIAlertAction(title: "Save".localized, style: .Default, handler: { action in
                self.buildObject()
                self.closeWindow()
            })
            controller.addAction(skeepDateAction)
            controller.addAction(saveDateAction)
            
            self.presentViewController(controller, animated: true, completion: nil)
        } else {
            self.closeWindow()
        }
    }
    
    func dataWasChanged() -> Bool{
        return self._orgTask != self.task
    }

    // This method builds an object, which properties were changed before in separated views
    // Builder is presented by just one class
    private func buildObject(){
        self.task!.save{(error: NSError?) in
            if let saveError = error{
                showAlertWithTitle("Update task error".localized, saveError.description)
            } else if let orgTask = self._orgTask{
                orgTask.cloneTask(self.task!)
            }
        }
    }

    func closeWindow() {
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
            let enterCategoryVC = storyboard.instantiateViewControllerWithIdentifier(SOEditTaskViewControllerId.Category.rawValue) as! SOEnterCategoryViewController
            enterCategoryVC.task = task
            self.navigationController!.pushViewController(enterCategoryVC, animated: true)
        case .IconsCell:
            let enterIconsVC = storyboard.instantiateViewControllerWithIdentifier(SOEditTaskViewControllerId.Icons.rawValue) as! SOEnterIconsViewController
            enterIconsVC.task = task
            self.navigationController!.pushViewController(enterIconsVC, animated: true)
        case .DateCell:
            let enterDateVC = storyboard.instantiateViewControllerWithIdentifier(SOEditTaskViewControllerId.Date.rawValue) as! SOEnterDateViewController
            enterDateVC.task = task
            enterDateVC.date = task?.date
            self.navigationController!.pushViewController(enterDateVC, animated: true)
        case .DescriptionCell:
            let enterDescrVC = storyboard.instantiateViewControllerWithIdentifier(SOEditTaskViewControllerId.Description.rawValue) as! SOEnterDescriptionViewController
            enterDescrVC.task = task
            self.navigationController!.pushViewController(enterDescrVC, animated: true)
        default:
            assert(false, "Rows is too much!")
        }
    }
    
    // - MARK:
    
    
}