//
//  SOMainViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOMainViewController: UIViewController{

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
        
        categoryTabBarController.filterStateDelegate = mainTableViewController
        iconsTabBarController.filterStateDelegate = mainTableViewController
        
        categoryTabBarController.reloadTabs()
        iconsTabBarController.reloadTabs()
        mainTableViewController.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
