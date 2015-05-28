//
//  SOMainViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
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

