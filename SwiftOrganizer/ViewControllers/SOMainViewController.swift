//
//  SOMainViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import DataBaseKit

protocol SOEditTaskController{
    func startEditingTask(task: Task?)
    func editTaskList()
}

class SOMainViewController: UIViewController{

    @IBOutlet weak var mainTableView: UITableView!
    var mainTableViewController: SOMainTableViewController!
    
    @IBOutlet weak var categoryTabBarView: SOTabBarContainerView!
    @IBOutlet weak var categoryScrollView: UIScrollView!
    
    @IBOutlet weak var iconsTabBarView: SOTabBarContainerView!
    @IBOutlet weak var iconsScrollView: UIScrollView!
    
    var categoryTabBarController: TaskCategoryTabBarController!
    var iconsTabBarController: TaskIconsTabBarController!

    var rightButton: UIBarButtonItem!

    private var _editTaskViewController: SOEditTaskViewController?
    
    var allTimes = [NSDate]()
    private var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allTimes.append(NSDate())
        
        categoryTabBarController = TaskCategoryTabBarController(scrollView: categoryScrollView, containerView: categoryTabBarView)
        iconsTabBarController = TaskIconsTabBarController(scrollView: iconsScrollView, containerView: iconsTabBarView)
        
        mainTableViewController = SOMainTableViewController(tableView: self.mainTableView, delegate: self)
        
        categoryTabBarController.filterStateDelegate = mainTableViewController
        iconsTabBarController.filterStateDelegate = mainTableViewController
        
        SOObserversManager.sharedInstance.addObserver(self, type: .SODataBaseTypeChanged)
        SOObserversManager.sharedInstance.addObserver(self, type: .SODataBaseDidChanged)
        
        /* Create the refresh control */
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(SOMainViewController.handleRefresh(_:)), forControlEvents: .ValueChanged)
        mainTableView.addSubview(refreshControl!)
        
        self.titleActualize()
        
        self.googleAnaliticsConfigure()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Google Analitics Tracker
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "MainViewController")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        //
        
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()

        let addTaskImage : UIImage! = UIImage(named: "add_task")
        let addTaskButton: UIBarButtonItem = UIBarButtonItem(image: addTaskImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SOMainViewController.addNewTask))
        let activityImage : UIImage! = UIImage(named: "activity")
        let activityButton: UIBarButtonItem = UIBarButtonItem(image: activityImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SOMainViewController.startActivityViewController))
        navigationItem.rightBarButtonItems = [addTaskButton, activityButton]
        
        //rightButton = UIBarButtonItem(title: "Activity".localized, style: UIBarButtonItemStyle.Plain, target: self, action: "startActivityViewController")
        //navigationItem.rightBarButtonItem = addTaskButton;
        
        self.reloadData({(error: NSError?) in })
    }

    deinit {
        SOObserversManager.sharedInstance.removeObserver(self, type: .SODataBaseTypeChanged)
        SOObserversManager.sharedInstance.removeObserver(self, type: .SODataBaseDidChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleRefresh(paramSender: AnyObject){
        /* Put a bit of delay between when the refresh control is released
        and when we actually do the refreshing to make the UI look a bit
        smoother than just doing the update without the animation */
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC))
        
        dispatch_after(popTime, dispatch_get_main_queue(), {[weak self] in
            self!.reloadData({(error: NSError?) in
                self!.allTimes.append(NSDate())
                self!.refreshControl!.endRefreshing()
            })
        })
    }
    
    private func reloadData(completionBlock: (error: NSError?) -> Void){
        self.categoryTabBarController.reloadTabs{(error: NSError?) in
            self.iconsTabBarController.reloadTabs{(error: NSError?) in
                self.cancelEditTask()
                self.mainTableViewController.reloadData()
                completionBlock(error: error)
                self.titleActualize()
            }
        }
    }

    private func titleActualize(){
        let defaultTitle = "Organizer".localized
        let currentDB = SOTypeDataBaseSwitcher.currectDataBaseDescription()
        self.title = "\(defaultTitle) (\(currentDB))"
    }
    
    // MARK: Edit Task List
    
    func startActivityViewController(){
        if self.mainTableView.editing{
            self.mainTableView.editing = false
            self.rightButton.title = "Activity".localized
        } else {
            let editTaskListActivity = TaskMenuItemActivity()
            editTaskListActivity.name = "EditTaskListActivity"
            editTaskListActivity.title = "Erase Task".localized
            editTaskListActivity.imageName = "ico12@2x"
            editTaskListActivity.performBlock = {
                self.editTaskList()
            }
            
            let newTaskActivity = TaskMenuItemActivity()
            newTaskActivity.name = "NewTaskActivity"
            newTaskActivity.title = "New Task".localized
            newTaskActivity.imageName = "add_task"
            newTaskActivity.performBlock = {
                self.addNewTask()
            }
            
            let switchDBtypeActivity = TaskMenuItemActivity()
            switchDBtypeActivity.name = "SwitchDBtypeActivity"
            switchDBtypeActivity.title = "Switch DB".localized
            switchDBtypeActivity.imageName = "ico10@2x"
            switchDBtypeActivity.performBlock = {
                SOTypeDataBaseSwitcher.switchToNextDataBase()
            }
            
            let activityController = UIActivityViewController(activityItems: [], applicationActivities: [editTaskListActivity, newTaskActivity, switchDBtypeActivity])
            presentViewController(activityController, animated: true, completion: nil)
        }
    }
    
    private var editTaskViewController: SOEditTaskViewController{
        if _editTaskViewController != nil {
            return _editTaskViewController!
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        _editTaskViewController = storyboard.instantiateViewControllerWithIdentifier("SOEditTaskViewController") as? SOEditTaskViewController
        
        return _editTaskViewController!
    }
    
    func cancelEditTask(){
        self.editTaskViewController.cancelEdit()
    }
    
    func addNewTask(){
        self.startEditingTask(nil)
    }

    func editTask(task: Task?){
        self.startEditingTask(task)
    }
}

    // MARK: Start editing task

extension SOMainViewController: SOEditTaskController{
    func startEditingTask(task: Task?){
        self.editTaskViewController.task = task
        self.navigationController!.pushViewController(self.editTaskViewController, animated: true)
    }
    
    func editTaskList(){
        self.rightButton.title = "Done".localized
        self.mainTableView.editing = true
    }
}

    // MARK: SOObserverNotificationTypes Observer notifications handler

extension SOMainViewController: SOObserverProtocol{
    func notify(notification: SOObserverNotification){
        switch notification.type{
        case .SODataBaseTypeChanged, .SODataBaseDidChanged:
            self.reloadData({(error: NSError?) in
                
            })
        }
    }
}

    // MARK: Alert View Controller

extension SOMainViewController{
    func showAlertWithTitle(title: String, message: String, addActions: ((controller: UIAlertController) -> Void)?, completionBlock: (() -> Void)?){
        let controller = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        if addActions != nil {
            addActions!(controller: controller)
        } else {
            controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        }
        presentViewController(controller, animated: true, completion: completionBlock)
    }
}


// MARK: Configure Google Analytics

extension SOMainViewController{
    
    func googleAnaliticsConfigure() {
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        
        self.showAlertWithTitle("Google Analitics", message: "With your permission usage information will be collected to improve the application.", addActions: { (controller: UIAlertController) in
            controller.addAction(UIAlertAction(title: "Opt Out", style: UIAlertActionStyle.Default,
                handler: {(alert: UIAlertAction!) in GAI.sharedInstance().optOut = true }))
            controller.addAction(UIAlertAction(title: "Opt In", style: UIAlertActionStyle.Default,
                handler: {(alert: UIAlertAction!) in GAI.sharedInstance().optOut = false }))
            },
                                                   completionBlock: nil)
    }
    
}

