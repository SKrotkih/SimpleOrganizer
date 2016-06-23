//
//  EditTaskIconsViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class EditTaskIconsViewController: EditTaskDetailViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var output: EditTaskIconsInteractorInput!
    var viewModel: EditTaskIconsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EditTaskIconsConfigurator.sharedInstance.configure(self)
        self.viewModel = EditTaskIconsViewModel(viewDataSource: [])
        self.title = "Icons".localized
        let rightButtonImage : UIImage! = UIImage(named: "save_task")
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: rightButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditTaskIconsViewController.doneButtonWasPressed))
        navigationItem.rightBarButtonItem = rightButton;
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.output.fetchData()
    }

    func redrawView(viewModel: EditTaskIconsViewModel){
        dispatch_async(dispatch_get_main_queue(), {
            self.viewModel = viewModel
            self.tableView.reloadData()
        })
    }
    
    func doneButtonWasPressed() {
        self.output.saveData()
        super.closeButtonWasPressed()
    }
    
    override func willFinishEditing() -> Bool{
        if self.output.dataWasChanged() {
            let controller = UIAlertController(title: "Data was chenged!".localized, message: nil, preferredStyle: .ActionSheet)
            let skeepDateAction = UIAlertAction(title: "Discard".localized, style: .Cancel, handler: { action in
                self.output.fetchTaskIcons()
                super.closeButtonWasPressed()
            })
            let saveDateAction = UIAlertAction(title: "Save".localized, style: .Default, handler: { action in
                self.doneButtonWasPressed()
            })
            controller.addAction(skeepDateAction)
            controller.addAction(saveDateAction)
            self.presentViewController(controller, animated: true, completion: nil)
            return false
        } else {
            return super.willFinishEditing()
        }
    }
}

    // MARK: UITableViewDataSource

extension EditTaskIconsViewController: UITableViewDataSource{
    
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.viewDataSource.count
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "selectIconsCell"
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! SOSelectIconsCell
        let dictionary: Dictionary<String, AnyObject> = self.viewModel.viewDataSource[indexPath.row]
        let icoImageName = dictionary["imagename"] as! String
        let checkBoxImageName = dictionary["checkboximagename"] as! String
        cell.icoImageView.image = UIImage(named: icoImageName)
        cell.checkImageView.image = UIImage(named: checkBoxImageName)
        return cell
    }
    
}

    // MARK: UITableViewDelegate

extension EditTaskIconsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.output.addIconWithIndex(indexPath.row)
    }
}
