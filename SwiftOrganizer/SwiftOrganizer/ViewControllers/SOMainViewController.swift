//
//  SOMainViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

protocol SOEditTaskController{
    func startEditingOfTask(task: SOTask?)
}

class SOMainViewController: UIViewController, SOEditTaskController, SOObserverProtocol{

    @IBOutlet weak var mainTableView: UITableView!
    var mainTableViewController: SOMainTableViewController!
    
    @IBOutlet weak var categoryTabBarView: SOTabBarContainerView!
    @IBOutlet weak var categoryScrollView: UIScrollView!
    
    @IBOutlet weak var iconsTabBarView: SOTabBarContainerView!
    @IBOutlet weak var iconsScrollView: UIScrollView!
    
    var categoryTabBarController: SOCategoryTabBarController!
    var iconsTabBarController: SOIconsTabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTabBarController = SOCategoryTabBarController(scrollView: categoryScrollView, containerView: categoryTabBarView)
        iconsTabBarController = SOIconsTabBarController(scrollView: iconsScrollView, containerView: iconsTabBarView)
        
        mainTableViewController = SOMainTableViewController(tableView: self.mainTableView)
        mainTableViewController.taskEditingDelegate = self
        
        categoryTabBarController.filterStateDelegate = mainTableViewController
        iconsTabBarController.filterStateDelegate = mainTableViewController
        
        self.title = "Organizer".localized
        
        SOObserversManager.sharedInstance.addObserver(self, type: .SODataBaseTypeChanged)
    }

    deinit {
        SOObserversManager.sharedInstance.removeObserver(self, type: .SODataBaseTypeChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()

        let buttonImage : UIImage! = UIImage(named: "add_task")
        var rightButton: UIBarButtonItem = UIBarButtonItem(image: buttonImage, style: UIBarButtonItemStyle.Plain, target: self, action: "addNewTask")
            navigationItem.rightBarButtonItem = rightButton;
        
        self.reloadData()
    }

    private func reloadData(){
        self.categoryTabBarController.reloadTabs{(error: NSError?) in
            self.iconsTabBarController.reloadTabs{(error: NSError?) in
                self.mainTableViewController.reloadData()
            }
        }
    }

    func addNewTask(){
        self.startEditingOfTask(nil)
    }

    func editTask(task: SOTask?){
        self.startEditingOfTask(task)
    }

    func startEditingOfTask(task: SOTask?){
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newTaskRecordViewController = storyboard.instantiateViewControllerWithIdentifier("SOEditTaskViewController") as! SOEditTaskViewController
        newTaskRecordViewController.task = task
        self.navigationController!.pushViewController(newTaskRecordViewController, animated: true)
    }
    
    //- MARK: Helper Methods
    func showAlertWithTitle(title:String, message:String){
        var controller = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }

    //- MARK: SOObserverProtocol implementation
    func notify(notification: SOObserverNotification){
        switch notification.type{
        case .SODataBaseTypeChanged:
            self.reloadData()
        default:
            assert(false, "That observer type is absent!")
        }
    }
    
}
