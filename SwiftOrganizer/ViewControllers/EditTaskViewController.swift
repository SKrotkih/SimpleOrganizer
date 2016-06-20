//
//  EditTaskViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import Social

enum EditTaskViewControllerId: String {
    case Category = "EnterCategoryVC"
    case Icons = "EnterIconsVC"
    case Date = "EnterDateVC"
    case Description = "EnterDescriptionVC"
}

enum EditTaskDetailCellId: Int {
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

enum SOEditTaskFiledName: String {
    case CategoryFldName = "category"
    case IconsFldName = "icons"
    case DateFldName = "date"
    case DescriptionFldName = "title"
}

public protocol SOEditTaskUndoDelegateProtocol{
    func addToUndoBuffer(dict: NSDictionary)
}

protocol DetailsViewControllerDelegate {
    var input: EditTaskInteractorInput! {get set}
}

extension EditTaskViewController: DetailsViewControllerDelegate{
    
}

    // MARK: Class EditTaskViewController

class EditTaskViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var input: EditTaskInteractorInput!
    
    var needToReloadData: Bool = true
    
    private var _cells = [EditTaskDetailCell](count: EditTaskDetailCellId.Undefined.rawValue, repeatedValue: EditTaskDetailCell())
    private let _undoManager = NSUndoManager()

    override func awakeFromNib()
    {
        super.awakeFromNib()
        EditTaskConfigurator.sharedInstance.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _undoManager.prepareWithInvocationTarget(self)
        self.prepareView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if needToReloadData {
            self.input.prepareTaskData()
        } else {
           needToReloadData = true
        }
    }

    @IBAction func unwindToEditTaskViewController(segue: UIStoryboardSegue) {
        needToReloadData = false
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func prepareView(){
        let leftButtonImage: UIImage! = UIImage(named: "back_button")
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: leftButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditTaskViewController.closeButtonWasPressed))
        navigationItem.leftBarButtonItem = leftButton;
        
        let rightButtonImage : UIImage! = UIImage(named: "save_task")
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: rightButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditTaskViewController.doneButtonWasPressed))
        
        let undoButtonImage : UIImage! = UIImage(named: "undo")
        let undoButton: UIBarButtonItem = UIBarButtonItem(image: undoButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditTaskViewController.undoButtonWasPressed))
        
        navigationItem.rightBarButtonItems = [undoButton, rightButton];
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    // MARK: UNDO
    
    func undoButtonWasPressed() {
        _undoManager.undo()
        self.tableView.reloadData()
    }
    
    // - MARK: Sharing Tasks on Button press handlers

    @IBAction func shareButtonPressed(sender: AnyObject) {
        self.pressOnShareButtonHandler()
    }

    @IBAction func shareComposeFacebookButtonPressed(sender: AnyObject) {
        self.shareComposeFacebook()
    }
    
    @IBAction func shareComposeTwitterButtonPressed(sender: AnyObject) {
        self.shareComposeTwitter()
    }
    
    // - MARK: Exit with close window
    
    func doneButtonWasPressed() {
        self.input.saveTask()
    }
    
    func closeButtonWasPressed() {
        if self.input.wasDataChanged() {
            
            let controller = UIAlertController(title: "Data was changed!".localized, message: nil, preferredStyle: .ActionSheet)
            let skeepDateAction = UIAlertAction(title: "Discard".localized, style: .Cancel, handler: { action in
                self.closeWindow()
            })
            let saveDateAction = UIAlertAction(title: "Save".localized, style: .Default, handler: { action in
                self.input.saveTask()
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
    
    func cancelToEdit(){
        if let navController = self.navigationController{
            let currentTopViewController = topViewController(navController)
            
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

    // MARK: EditTaskInteractorOutput (interactor calls)

extension EditTaskViewController: EditTaskInteractorOutput {

    func didReceiveData() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
}

    // MARK: - UITableViewDataSource

extension EditTaskViewController: UITableViewDataSource {

    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditTaskDetailCellId.Undefined.rawValue
    }
    
    // Customizing the row height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) ->
        CGFloat {
            return 44
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row: EditTaskDetailCellId = EditTaskDetailCellId(rawValue: indexPath.row)!
        let cellId: String = row.toString()
        
        switch row{
        case .CategoryCell:
            _cells[0] = self.tableView.dequeueReusableCellWithIdentifier(cellId) as! EditTaskCategoryCell
            _cells[0].delegate = self
            _cells[0].displayContent()
            
            return _cells[0]
            
        case .IconsCell:
            _cells[1] = self.tableView.dequeueReusableCellWithIdentifier(cellId) as! EditTaskIconsCell
            _cells[1].delegate = self
            _cells[1].displayContent()
            
            return _cells[1]
            
        case .DateCell:
            _cells[2] = self.tableView.dequeueReusableCellWithIdentifier(cellId) as! EditTaskDateCell
            _cells[2].delegate = self
            _cells[2].displayContent()
            
            return _cells[2]
            
        case .DescriptionCell:
            _cells[3] = self.tableView.dequeueReusableCellWithIdentifier(cellId) as! EditTaskDescriptionCell
            _cells[3].delegate = self
            _cells[3].displayContent()
            
            return _cells[3]
            
        default:
            assert(false, "Rows is too much!")
            let cell = self.tableView.dequeueReusableCellWithIdentifier(EditTaskDetailCellId.Undefined.toString()) as? EditTaskCategoryCell
            
            return cell!
        }
    }
}

    // MARK: UITableViewDelegate

extension EditTaskViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController: UIViewController!
        let task = self.input.task
        
        let row: EditTaskDetailCellId = EditTaskDetailCellId(rawValue: indexPath.row)!
        switch row{
        case .CategoryCell:
            let enterCategoryVC = storyboard.instantiateViewControllerWithIdentifier(EditTaskViewControllerId.Category.rawValue) as! SOEditCategoryViewController
            enterCategoryVC.task = task
            enterCategoryVC.undoDelegate = self
            viewController = enterCategoryVC
        case .IconsCell:
            let enterIconsVC = storyboard.instantiateViewControllerWithIdentifier(EditTaskViewControllerId.Icons.rawValue) as! SOEditIconsViewController
            enterIconsVC.task = task
            enterIconsVC.undoDelegate = self
            viewController = enterIconsVC
        case .DateCell:
            let enterDateVC = storyboard.instantiateViewControllerWithIdentifier(EditTaskViewControllerId.Date.rawValue) as! SOEditDateViewController
            enterDateVC.task = task
            enterDateVC.undoDelegate = self
            enterDateVC.date = task?.date
            viewController = enterDateVC
        case .DescriptionCell:
            let enterDescrVC = storyboard.instantiateViewControllerWithIdentifier(EditTaskViewControllerId.Description.rawValue) as! SOEditDescriptionViewController
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

extension EditTaskViewController: SOEditTaskUndoDelegateProtocol{

    func addToUndoBuffer(dict: NSDictionary){
        _undoManager.registerUndoWithTarget(self, selector: #selector(EditTaskViewController.undoData(_:)), object: dict);
    }

    @objc func undoData(data: [String: AnyObject]) {
        if let fldName = data.keys.first{
            let task = self.input.task
            
            switch fldName{
            case SOEditTaskFiledName.CategoryFldName.rawValue:
                let prevCategory = data[fldName] as! String
                task?.category = prevCategory
            case SOEditTaskFiledName.IconsFldName.rawValue:
                let prevIcons = data[fldName] as! NSArray
                task?.icons = prevIcons as! [String]
            case SOEditTaskFiledName.DateFldName.rawValue:
                let prevDate = data[fldName] as! String
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                let date = dateFormatter.dateFromString(prevDate)
                task?.date = date
            case SOEditTaskFiledName.DescriptionFldName.rawValue:
                let prevDescription = data[fldName] as! String
                task?.title = prevDescription
            default:
                print("Error: Something wrong with undo buffer keys!")
            }
        }
    }
    
}

    // MARK: Share Compose

extension EditTaskViewController {
    
    func pressOnShareButtonHandler() {
        var text: String = "SwiftOrganizer: "
        
        for cell in _cells{
            let str = cell.stringData()
            
            if str.characters.count > 0{
                text += str + "; "
            }
        }
        
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        self.presentViewController(activity, animated: true, completion: nil)
    }
    
    func shareComposeFacebook() {
        var text: String = "SwiftOrganizer: "
        
        for cell in _cells{
            let str = cell.stringData()
            
            if str.characters.count > 0{
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
                print("Completed")
            }
            presentViewController(controller, animated: true, completion: nil)
            
        } else {
            print("The Facebook service is not available".localized)
        }
    }
    
    func shareComposeTwitter() {
        var text: String = "SwiftOrganizer: "
        
        for cell in _cells{
            let str = cell.stringData()
            
            if str.characters.count > 0{
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
                print("Completed")
            }
            presentViewController(controller, animated: true, completion: nil)
            
        } else {
            print("The Facebook service is not available".localized)
        }
    }
}
