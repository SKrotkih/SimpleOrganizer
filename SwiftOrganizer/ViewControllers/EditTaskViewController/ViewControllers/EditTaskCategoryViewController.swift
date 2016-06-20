//
//  EditTaskCategoryViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class EditTaskCategoryViewController: EditTaskDetailViewController {

    private var categories: [TaskCategory] = [TaskCategory]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Category".localized
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.fetchData{
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    override func willFinishEditing() -> Bool{
        return true && super.willFinishEditing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

    // MARK: -

extension EditTaskCategoryViewController{
    private func fetchData(completionBlock: ()-> Void){
        SOFetchingData.sharedInstance.allCategories{(categories: [TaskCategory], fetchError: NSError?) in
            if let error = fetchError{
                showAlertWithTitle("Failed to fetch data".localized, message: error.description)
            } else {
                self.categories = categories.filter {(category: TaskCategory) in category.visible }
                completionBlock()
            }
        }
    }
}

    // MARK: UITableViewDataSource

extension EditTaskCategoryViewController: UITableViewDataSource {

    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 44
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let selectCategoryCell = "selectCategoryCell"
        let cell = self.tableView.dequeueReusableCellWithIdentifier(selectCategoryCell) as! SOSelectCategoryCell
        let row = indexPath.row
        let categoryId = categories[row].recordid
        let categoryName = categories[row].name
        cell.categoryNameLabel.text = categoryName
        cell.accessoryType = .None
        
        if let theTask = self.delegate?.input.task{
            if theTask.category == categoryId{
                cell.accessoryType = .Checkmark
            }
        }
        
        return cell
    }
}

    // MARK: UITableViewDelegate

extension EditTaskCategoryViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if let theTask = self.delegate?.input.task{
            let dict = NSDictionary(objects: [theTask.category], forKeys: ["category"])
            self.undoDelegate?.addToUndoBuffer(dict)
            
            let row = indexPath.row
            theTask.category = categories[row].recordid
        }
        
        super.closeButtonWasPressed()
    }
}
