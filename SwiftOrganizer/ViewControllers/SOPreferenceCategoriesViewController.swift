//
//  SOPreferenceCategoriesViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 9/3/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOPreferenceCategoriesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var buffer: [AnyObject] = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Categories".localized
        
        let rightButtonImage : UIImage! = UIImage(named: "save_task")
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: rightButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SOPreferenceCategoriesViewController.doneButtonWasPressed))
        navigationItem.rightBarButtonItem = rightButton;
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchData {
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }

    }
    
    func didSelectRow(aRow: Int){
        let category: TaskCategory = self.buffer[aRow] as! TaskCategory
        let currState: Bool = !category.visible
        category.setVisible(currState, completionBlock: {(error: NSError?) in
            if let theError = error{
                showAlertWithTitle("Failed to save data".localized, message: theError.description)
            } else {
                self.fetchData {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
            }
        })
    }
    
    func doneButtonWasPressed(){
        
        // TODO: Need to implement Mememnto Design Pattern
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension SOPreferenceCategoriesViewController{
    private func fetchData(completionBlock: () -> Void ){
        SOFetchingData.sharedInstance.allCategories{(categories: [TaskCategory], fetchError: NSError?) in
            if let error = fetchError{
                self.buffer.removeAll(keepCapacity: false)
                showAlertWithTitle("Failed to fetch data".localized, message: error.description)
            } else {
                self.buffer = categories
                completionBlock()
            }
        }
    }
}

    // MARK: - UITableViewDelegate, UITableViewDataSource

extension SOPreferenceCategoriesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buffer.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! SOPreferencesSelectCategoriesCell

        let category: TaskCategory = self.buffer[indexPath.row] as! TaskCategory
        
        cell.categoryNameLabel.text = category.name
        
        let checkBoxImageName: String = category.visible ? "check_box": "uncheck_box"
        cell.checkImageView.image = UIImage(named: checkBoxImageName)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.didSelectRow(indexPath.row)
    }
    
}

