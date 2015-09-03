//
//  SOEditTaskViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import Social

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

public protocol SOEditTaskUndoDelegateProtocol{
    func addToUndoBuffer(dict: NSDictionary)
}

class SOEditTaskViewController: UIViewController {

    private var _task: SOTask
    private var _orgTask: SOTask?
    private var isItNewTask: Bool
    private var _cells = [SOEditTaskCell](count: SOEditTaskCellId.Undefined.rawValue, repeatedValue: SOEditTaskCell())
    
    private let _undoManager = NSUndoManager()
    
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

        self.title = ""
        
        _undoManager.prepareWithInvocationTarget(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if isItNewTask{
            self.title = "New Task".localized
        } else {
            self.title = "Edit Task".localized
        }
        
        let leftButtonImage: UIImage! = UIImage(named: "back_button")
        var leftButton: UIBarButtonItem = UIBarButtonItem(image: leftButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: "closeButtonWasPressed")
        navigationItem.leftBarButtonItem = leftButton;
        
        let rightButtonImage : UIImage! = UIImage(named: "save_task")
        var rightButton: UIBarButtonItem = UIBarButtonItem(image: rightButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonWasPressed")

        let undoButtonImage : UIImage! = UIImage(named: "undo")
        var undoButton: UIBarButtonItem = UIBarButtonItem(image: undoButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: "undoButtonWasPressed")
        
        navigationItem.rightBarButtonItems = [undoButton, rightButton];
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        
        self.tableView.reloadData()
    }
    
    // MARK: UNDO
    
    func undoButtonWasPressed() {
        _undoManager.undo()
        self.tableView.reloadData()
    }
    
    // MARK: Edit data
    
    func dataWasChanged() -> Bool{
        if let orgTask = self._orgTask{
            return !orgTask.isEqual(self.task)
        } else if isItNewTask {
            let puretask = SOTask()
            puretask.clearTask()
            return !puretask.isEqual(self.task)
        }
        
        return false
    }
    
    // This method builds an object, which properties were changed before in separated views
    // Builder is presented by just one class
    private func buildObject(){
        self.task!.save{(error: NSError?) in
            if let saveError = error{
                showAlertWithTitle("Update task error".localized, saveError.description)
            } else if let orgTask = self._orgTask{
                orgTask.cloneTask(self.task!)
            } else if self.isItNewTask{
                self.isItNewTask = false
                self._orgTask = SOTask()
                self._orgTask!.cloneTask(self.task!)
            }
        }
    }
    
    // - MARK:
    @IBAction func shareButtonPressed(sender: AnyObject) {
        var text: String = "SwiftOrganizer: "
        
        for cell in _cells{
            let str = cell.currentValueToString()
            
            if count(str) > 0{
                text += str + "; "
            }
        }
        
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        self.presentViewController(activity, animated: true, completion: nil)
    }

    @IBAction func shareComposeFacebookButtonPressed(sender: AnyObject) {
        var text: String = "SwiftOrganizer: "
        
        for cell in _cells{
            let str = cell.currentValueToString()
            
            if count(str) > 0{
                text += str + "; "
            }
        }
        
        let serviceType = SLServiceTypeFacebook
        
        if SLComposeViewController.isAvailableForServiceType(serviceType){
            let controller = SLComposeViewController(forServiceType: serviceType)
            controller.setInitialText(text)
            controller.addImage(UIImage(named: "ico1@2x"))
            controller.addURL(NSURL(string: "http://www.apple.com/safari/"))
            controller.completionHandler = {(result: SLComposeViewControllerResult) in
                println("Completed")
            }
            presentViewController(controller, animated: true, completion: nil)

        } else {
            println("The Facebook service is not available".localized)
        }
    }
    
    @IBAction func shareComposeTwitterButtonPressed(sender: AnyObject) {
        var text: String = "SwiftOrganizer: "
        
        for cell in _cells{
            let str = cell.currentValueToString()
            
            if count(str) > 0{
                text += str + "; "
            }
        }
        
        let serviceType = SLServiceTypeTwitter
        
        if SLComposeViewController.isAvailableForServiceType(serviceType){
            let controller = SLComposeViewController(forServiceType: serviceType)
            controller.setInitialText(text)
            controller.addImage(UIImage(named: "ico1@2x"))
            controller.addURL(NSURL(string: "http://www.apple.com/safari/"))
            controller.completionHandler = {(result: SLComposeViewControllerResult) in
                println("Completed")
            }
            presentViewController(controller, animated: true, completion: nil)
            
        } else {
            println("The Facebook service is not available".localized)
        }
        
        
    }
    
    // - MARK: Exit with close window
    
    func doneButtonWasPressed() {
        self.buildObject()
    }
    
    func closeButtonWasPressed() {
        if dataWasChanged() {
            
            let controller = UIAlertController(title: "Data was changed!".localized, message: nil, preferredStyle: .ActionSheet)
            let skeepDateAction = UIAlertAction(title: "Discard".localized, style: .Cancel, handler: { action in
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
    
    func closeWindow() {
        self.navigationController?.popViewControllerAnimated(true)

        _undoManager.removeAllActions()
    }
    
    func cancelEdit(){
        if let navController = self.navigationController{
            let currentTopViewController = topViewController(base: navController)
            
            if currentTopViewController == self{
                closeButtonWasPressed()
            } else if currentTopViewController!.isKindOfClass(SOEditTaskFieldBaseViewController){
                let editTaskFieldViewController = currentTopViewController as! SOEditTaskFieldBaseViewController
                editTaskFieldViewController.closeButtonWasPressed()
                dispatch_async(dispatch_get_main_queue(), {
                    self.closeButtonWasPressed()
                })
            }
        }
    }
    
}

extension SOEditTaskViewController: UITableViewDataSource {

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
            _cells[0] = self.tableView.dequeueReusableCellWithIdentifier(cellId) as! SOEditTaskCategoryCell
            _cells[0].task = task!
            
            return _cells[0]
            
        case .IconsCell:
            _cells[1] = self.tableView.dequeueReusableCellWithIdentifier(cellId) as! SOEditTaskIconsCell
            _cells[1].task = task!
            
            return _cells[1]
            
        case .DateCell:
            _cells[2] = self.tableView.dequeueReusableCellWithIdentifier(cellId) as! SOEditTaskDateCell
            _cells[2].task = task!
            
            return _cells[2]
            
        case .DescriptionCell:
            _cells[3] = self.tableView.dequeueReusableCellWithIdentifier(cellId) as! SOEditTaskDescriptionCell
            _cells[3].task = task!
            
            return _cells[3]
            
        default:
            assert(false, "Rows is too much!")
            var cell = self.tableView.dequeueReusableCellWithIdentifier(SOEditTaskCellId.Undefined.toString()) as? SOEditTaskCategoryCell
            
            return cell!
        }
    }
}

extension SOEditTaskViewController: UITableViewDelegate{

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController: UIViewController!
        
        let row: SOEditTaskCellId = SOEditTaskCellId(rawValue: indexPath.row)!
        switch row{
        case .CategoryCell:
            let enterCategoryVC = storyboard.instantiateViewControllerWithIdentifier(SOEditTaskViewControllerId.Category.rawValue) as! SOEditCategoryViewController
            enterCategoryVC.task = task
            enterCategoryVC.undoDelegate = self
            viewController = enterCategoryVC
        case .IconsCell:
            let enterIconsVC = storyboard.instantiateViewControllerWithIdentifier(SOEditTaskViewControllerId.Icons.rawValue) as! SOEditIconsViewController
            enterIconsVC.task = task
            enterIconsVC.undoDelegate = self
            viewController = enterIconsVC
        case .DateCell:
            let enterDateVC = storyboard.instantiateViewControllerWithIdentifier(SOEditTaskViewControllerId.Date.rawValue) as! SOEditDateViewController
            enterDateVC.task = task
            enterDateVC.undoDelegate = self
            enterDateVC.date = task?.date
            viewController = enterDateVC
        case .DescriptionCell:
            let enterDescrVC = storyboard.instantiateViewControllerWithIdentifier(SOEditTaskViewControllerId.Description.rawValue) as! SOEditDescriptionViewController
            enterDescrVC.task = task
            enterDescrVC.undoDelegate = self
            viewController = enterDescrVC
        default:
            assert(false, "Rows is too much!")
        }
        
        self.navigationController!.pushViewController(viewController, animated: true)
    }
}

    // MARK: Undo task data implementation

extension SOEditTaskViewController: SOEditTaskUndoDelegateProtocol{

    func addToUndoBuffer(dict: NSDictionary){
        _undoManager.registerUndoWithTarget(self, selector: "undoData:", object: dict);
    }

    @objc func undoData(data: [String: AnyObject]) {
        if let fldName = data.keys.first{
            switch fldName{
            case "category":
                let prevCategory = data[fldName] as! String
                self.task?.category = prevCategory
            case "icons":
                let prevIcons = data[fldName] as! NSArray
                self.task?.icons = prevIcons as! [String]
            case "date":
                let prevDate = data[fldName] as! String
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                var date = dateFormatter.dateFromString(prevDate)
                self.task?.date = date
            case "title":
                let prevDescription = data[fldName] as! String
                self.task?.title = prevDescription
            default:
                println("Error: Something wrong with undo buffer keys!")
            }
        }
    }
    
}


