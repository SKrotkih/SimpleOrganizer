//
//  EditTaskCategoryViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class EditTaskCategoryViewController: EditTaskDetailViewController {
    @IBOutlet weak var tableView: UITableView!
    var output: EditTaskCategoryInteractorInput!
    var viewModel: EditTaskCategoryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EditTaskCategoryConfigurator.sharedInstance.configure(self)
        self.viewModel = EditTaskCategoryViewModel(viewDataSource: [])
        self.title = "Category".localized
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.output.fetchData()
    }
    
    override func willFinishEditing() -> Bool{
        return true && super.willFinishEditing()
    }
    
    func redrawView(viewModel: EditTaskCategoryViewModel){
        dispatch_async(dispatch_get_main_queue(), {
            self.viewModel = viewModel
            self.tableView.reloadData()
        })
    }
}

// MARK: UITableViewDataSource

extension EditTaskCategoryViewController: UITableViewDataSource {
    
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.viewModel.viewDataSource.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "selectCategoryCell"
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! SOSelectCategoryCell
        let dictionary = self.viewModel.viewDataSource[indexPath.row]
        cell.categoryNameLabel.text = dictionary["name"] as? String
        cell.accessoryType = dictionary["selected"] as! String == "yes" ? .Checkmark: .None
        return cell
    }
}

// MARK: UITableViewDelegate

extension EditTaskCategoryViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let dict = NSDictionary(objects: [self.input.task.category], forKeys: ["category"])
        self.undoDelegate?.addToUndoBuffer(dict)

        self.output.selectDataWithIndex(indexPath.row)
        self.output.saveData()
        super.closeButtonWasPressed()
    }
}
