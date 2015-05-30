//
//  SOMainViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOMainViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    var mainTableViewController: SOMainTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableViewController = SOMainTableViewController(tableView: self.mainTableView)
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
