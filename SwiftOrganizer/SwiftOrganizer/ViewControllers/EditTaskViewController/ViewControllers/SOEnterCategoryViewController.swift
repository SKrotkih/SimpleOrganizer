//
//  SOEnterCategoryViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOEnterCategoryViewController: SOEnterBaseViewController {

    var categories: [SOCategory]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Category".localized

        SODataFetching.sharedInstance.allCategories{(categories: [SOCategory], fetchError: NSError?) in
            if let error = fetchError{
                showAlertWithTitle("Error reading categories data", error.description)
            } else {
                self.categories = categories
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SOEnterCategoryViewController: UITableViewDataSource {

    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) ->
        CGFloat {
            return 44
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let selectCategoryCell = "selectCategoryCell"
        let row = indexPath.row
        var cell = self.tableView.dequeueReusableCellWithIdentifier(selectCategoryCell) as! SOSelectCategoryCell
        let categoryName = categories[row].name
        cell.categoryNameLabel.text = categoryName
        
        return cell
    }
}

extension SOEnterCategoryViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if let theTask = self.task{
            let dict = NSDictionary(objects: [theTask.category], forKeys: ["category"])
            self.undoDelegate?.addToUndoBuffer(dict)
            
            let row = indexPath.row
            theTask.category = categories[row].id
        }
        
        super.closeButtonWasPressed()
    }
}
