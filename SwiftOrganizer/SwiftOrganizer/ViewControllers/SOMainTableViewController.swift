//
//  SOMainTableViewController.swift
//  SimpleTable
//
//  Created by Domenico on 22.04.15.
//  Copyright (c) 2015 Domenico Solazzo. All rights reserved.
//

import UIKit

class SOMainTableViewController: NSObject, UITableViewDataSource, UITableViewDelegate {

    let tableView : UITableView
    
    private let dwarves = [
        "Sleepy", "Sneezy", "Bashful", "Happy",
        "Doc", "Grumpy", "Dopey",
        "Thorin", "Dorin", "Nori", "Ori",
        "Balin", "Dwalin", "Fili", "Kili",
        "Oin", "Gloin", "Bifur", "Bofur",
        "Bombur"
    ]
    let mainTableViewCellIdentifier = "MainTableViewCell"
    let mainHeaderTableViewCellIdentifier = "HeaderTableViewCell"
    
    init(tableView aTavleView: UITableView){
        self.tableView = aTavleView
        super.init()
        self.tableView.delegate = self;
        self.tableView.dataSource = self
    }

    func reloadData(){
        
        self.tableView.reloadData()
    }
    
    //- MARK: UITableViewDataSource
    /// Number of row in a section
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dwarves.count
    }
    
    /// It is called by the table view when it needs to draw one of its rows.
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Reuse a cell of the specified type
        
        if indexPath.row == 0{
            var cell = self.tableView.dequeueReusableCellWithIdentifier(mainHeaderTableViewCellIdentifier) as? UITableViewCell
            
            return cell!
        }
        else
        {
            var cell = self.tableView.dequeueReusableCellWithIdentifier(mainTableViewCellIdentifier) as? SOMainTableViewCell
            cell!.titleTextLabel!.text = dwarves[indexPath.row]
            
            return cell!
        }
    }

    //- MARK: UITableViewDelegate
    func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
            return indexPath.row % 4
    }
    // Before the row is selected
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath)
        -> NSIndexPath? {
            if indexPath.row == 0 {
                return nil
            } else {
                return indexPath
            }
    }
    
    // After the row is selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let rowValue = dwarves[indexPath.row]
            let message = "You selected \(rowValue)"
            
    }
    
    // Customizing the row height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath)
        -> CGFloat {
            return indexPath.row == 0 ? 44 : 47
    }


}
