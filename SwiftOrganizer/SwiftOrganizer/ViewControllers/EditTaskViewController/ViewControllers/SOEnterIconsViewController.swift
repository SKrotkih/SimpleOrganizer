//
//  SOEnterIconsViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOEnterIconsViewController: SOEnterBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var icons = [SOIco]()
    var taskIcons = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        icons = SODataFetching.sharedInstance.allIcons
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let rightButtonImage : UIImage! = UIImage(named: "save_task")
        var rightButton: UIBarButtonItem = UIBarButtonItem(image: rightButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonWasPressed")
        navigationItem.rightBarButtonItem = rightButton;
        
        if let editTask = self.task{
            taskIcons.removeAll(keepCapacity: false)
            let icons = editTask.icons

            for i in 0..<icons.count{
                let icoId = icons[i]

                if icoId != ""{
                    taskIcons.append(icoId)
                }
            }
        }
    }
    
    func doneButtonWasPressed() {
        if let editTask = self.task{
            let icons = editTask.icons
            for i in 0..<icons.count{
                var newIconValue = ""
                if i < taskIcons.count{
                    newIconValue = taskIcons[i]
                }
                editTask.setIcon(i, newValue: newIconValue)
            }
        }
        
        super.closeButtonWasPressed()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //- MARK: UITableViewDataSource
    /// Number of rows in a section
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let selectIconsCell = "selectIconsCell"
        let row = indexPath.row
        var cell = self.tableView.dequeueReusableCellWithIdentifier(selectIconsCell) as! SOSelectIconsCell

        let ico: SOIco = icons[row]
        let icoId: String = ico.id
        
        if let icoImageName = SODataFetching.sharedInstance.iconsImageName(icoId){
            cell.icoImageView.image = UIImage(named: icoImageName)
        }
        
        var checkBoxImageName: String = "uncheck_box"
        
        for i in 0..<taskIcons.count{
            if icoId == taskIcons[i]{
                checkBoxImageName =  "check_box"

                break
            }
        }
        cell.checkImageView.image = UIImage(named: checkBoxImageName)
        
        return cell
    }
    
    //- MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let ico: SOIco = icons[row]
        let icoId: String = ico.id
        var needAdd: Bool = true

        for i in 0..<taskIcons.count{
            if icoId == taskIcons[i]{
                taskIcons.removeAtIndex(i)
                needAdd = false
                
                break
            }
        }
        
        if needAdd && taskIcons.count <= task?.maxIconsCount{
            taskIcons.append(icoId)
        }
        
        self.tableView.reloadData()
    }
    // - MARK:

}
