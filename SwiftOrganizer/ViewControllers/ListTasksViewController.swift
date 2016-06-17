//
//  ListTasksViewController.swift
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

protocol SOChangeFilterStateDelegate{
    func didSelectCategory(category: TaskCategory, select: Bool, completionBlock: (error: NSError?) -> Void)
    func didSelectIcon(icon: TaskIco, select: Bool, completionBlock: (error: NSError?) -> Void)
}

let TableViewCellIdentifier: String = "MainTableViewCell"
let HeaderTableViewCellIdentifier: String = "HeaderTableViewCell"
let HeightOfTableRow: CGFloat = 47.0
let HeightOfTableHeader: CGFloat = 28.0

class ListTasksViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var categoryTabBarView: TabBarContainerView!
    @IBOutlet weak var categoryScrollView: UIScrollView!
    
    @IBOutlet weak var iconsTabBarView: TabBarContainerView!
    @IBOutlet weak var iconsScrollView: UIScrollView!
    
    var categoryTabBarController: TaskCategoryTabBarController!
    var iconsTabBarController: TaskIconsTabBarController!

    var rightButton: UIBarButtonItem!
    
    var router: ListTasksRouter!
    var output: ListTasksInteractor!

    private var _editTaskViewController: SOEditTaskViewController?
    
    var allTimes = [NSDate]()
    private var refreshControl: UIRefreshControl?
    
    var tasks : [ListTasks.FetchTasks.ViewModel.DisplayedTask] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ListTasksConfigurator.sharedInstance.configure(self)
        
        allTimes.append(NSDate())
        
        categoryTabBarController = TaskCategoryTabBarController(scrollView: categoryScrollView, containerView: categoryTabBarView)
        iconsTabBarController = TaskIconsTabBarController(scrollView: iconsScrollView, containerView: iconsTabBarView)
        
        categoryTabBarController.filterStateDelegate = self
        iconsTabBarController.filterStateDelegate = self
        
        SOObserversManager.sharedInstance.addObserver(self, type: .SODataBaseTypeChanged)
        SOObserversManager.sharedInstance.addObserver(self, type: .SODataBaseDidChanged)
        
        /* Create the refresh control */
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(ListTasksViewController.handleRefresh(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl!)
        
        self.titleActualize()
        
        self.googleAnaliticsConfigure()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Google Analitics Tracker
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "ListTasksViewController")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        //
        
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()

        let addTaskImage : UIImage! = UIImage(named: "add_task")
        let addTaskButton: UIBarButtonItem = UIBarButtonItem(image: addTaskImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ListTasksViewController.addNewTask))
        let activityImage : UIImage! = UIImage(named: "activity")
        let activityButton: UIBarButtonItem = UIBarButtonItem(image: activityImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ListTasksViewController.startActivityViewController))
        navigationItem.rightBarButtonItems = [addTaskButton, activityButton]
        
        rightButton = UIBarButtonItem(title: "Activity".localized, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ListTasksViewController.startActivityViewController))
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
                if error == nil {
                    self?.allTimes.append(NSDate())
                    self?.refreshControl!.endRefreshing()
                }
            })
        })
    }
    
    private func reloadData(completionBlock: (error: NSError?) -> Void){
        self.categoryTabBarController.reloadTabs{[weak self] (error: NSError?) in
            if error == nil {
                self?.iconsTabBarController.reloadTabs{[weak self] (error: NSError?) in
                    if error == nil {
                        self?.cancelEditTask()
                        self?.output.fetchTasks()
                    }
                    completionBlock(error: error)
                }
            } else {
                completionBlock(error: error)
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
        if self.tableView.editing{
            self.tableView.editing = false
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

// MARK: ListTasksPresenterOutput

extension ListTasksViewController: ListTasksPresenterOutput {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        router.passDataToNextScene(segue)
    }
    
    func displayFetchedTasks(viewModel: ListTasks.FetchTasks.ViewModel){
        self.tasks = viewModel.displayedTasks
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            self.titleActualize()
        })
    }
}


// MARK: SOChangeFilterStateDelegate

extension ListTasksViewController: SOChangeFilterStateDelegate{
    func didSelectCategory(category: TaskCategory, select: Bool, completionBlock: (error: NSError?) -> Void){
        self.output.selectCategory(category, select: select, completionBlock: { (error: NSError?) in
            completionBlock(error: error)
        })
    }
    
    func didSelectIcon(icon: TaskIco, select: Bool, completionBlock: (error: NSError?) -> Void){
        self.output.selectIcon(icon, select: select, completionBlock: {(error: NSError?) in
            completionBlock(error: error)
        })
    }
}

// MARK: SORemoveTaskDelegate

extension ListTasksViewController: SORemoveTaskDelegate{
    func removeTask(taskID: AnyObject!){
        self.editTaskList()
    }
}

    // MARK: Start editing task

extension ListTasksViewController: SOEditTaskController{
    func startEditingTask(task: Task?){
        self.editTaskViewController.task = task
        self.navigationController!.pushViewController(self.editTaskViewController, animated: true)
    }
    
    func editTaskList(){
        self.rightButton.title = "Done".localized
        self.tableView.editing = true
    }
}

    // MARK: SOObserverNotificationTypes Observer notifications handler

extension ListTasksViewController: SOObserverProtocol{
    func notify(notification: SOObserverNotification){
        switch notification.type{
        case .SODataBaseTypeChanged, .SODataBaseDidChanged:
            self.reloadData({(error: NSError?) in
                
            })
        }
    }
}

// MARK: UITableViewDataSource

extension ListTasksViewController: UITableViewDataSource {
    
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier) as! ListTasksTableViewCell
        let row = indexPath.row
        let currentTask : ListTasks.FetchTasks.ViewModel.DisplayedTask = self.tasks[row]
        cell.fillTaskData(currentTask)
        cell.removeTaskDelegate = self
        return cell
    }
}

// MARK: UITableViewDelegate

extension ListTasksViewController: UITableViewDelegate {
    
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
            let task: ListTasks.FetchTasks.ViewModel.DisplayedTask = self.tasks[row]
            self.output.removeTask(task)
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
        let currentTask : ListTasks.FetchTasks.ViewModel.DisplayedTask = self.tasks[row]
        //self.startEditingTask(currentTask)
    }
    
    // Customizing the row height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HeightOfTableRow
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        switch section {
        case 0:
            return HeightOfTableHeader
        default:
            return 0.0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let headerCell = self.tableView.dequeueReusableCellWithIdentifier(HeaderTableViewCellIdentifier)
        
        return headerCell
    }
}

// MARK: Alert View Controller

extension ListTasksViewController{
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

extension ListTasksViewController{
    
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
