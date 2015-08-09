//
//  SOEditIconsViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOEditIconsViewController: SOEditTaskFieldBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private var icons = [SOIco]()
    private var taskIcons = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Icons".localized        

        SODataFetching.sharedInstance.allIcons{(icons: [SOIco], fetchError: NSError?) in
            if let error = fetchError{
                showAlertWithTitle("Error reading icons data", error.description)
            } else {
                self.icons = icons
                self.tableView.reloadData()
            }
        }
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
    
    func fillIconsBuffer() -> [String]{
        if let editTask = self.task{
            let iconsCount = editTask.icons.count
            var buffer = [String](count: iconsCount, repeatedValue: "")
            
            for i in 0..<iconsCount{
                if i < taskIcons.count{
                    buffer[i] = taskIcons[i]
                }
            }
        
            return buffer
        }

        return []
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SOEditIconsViewController: UITableViewDataSource{
    
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let selectIconsCell = "selectIconsCell"
        let row = indexPath.row
        var cell = self.tableView.dequeueReusableCellWithIdentifier(selectIconsCell) as! SOSelectIconsCell
        
        let ico: SOIco = icons[row]
        let icoId: String = ico.id
        
        if let icoImageName = SODataFetching.sharedInstance.iconImageName(icoId){
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
    
}

extension SOEditIconsViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let ico: SOIco = icons[row]
        let icoId: String = ico.id
        var needAdd: Bool = true

        let dict = NSDictionary(objects: [fillIconsBuffer()], forKeys: ["icons"])
        self.undoDelegate?.addToUndoBuffer(dict)
        
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
}