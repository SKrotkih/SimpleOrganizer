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
        self.reloadData()
    }
    
    private func reloadData(){
        if let theTask = self.task{
            taskIcons.removeAll(keepCapacity: false)
            let icons = theTask.icons
            
            for i in 0..<icons.count{
                let icoId = icons[i]
                
                if icoId != ""{
                    taskIcons.append(icoId)
                }
            }
        }
    }
    
    override func willFinishOfEditing() -> Bool{
        var needAsk: Bool = false

        if let theTask = self.task{
            let icons = theTask.icons
            var countIcons: Int = 0
            
            for i in 0..<icons.count{
                let icoId: String = icons[i]
                
                if count(icoId) > 0{
                    if filter(self.taskIcons, {
                        return $0 == icoId
                    }).count == 0{
                        needAsk = true
                        break
                    }
                    countIcons++
                }
            }
            
            if !needAsk && countIcons != self.taskIcons.count{
                needAsk = true
            }
            
        }

        if needAsk{
            let controller = UIAlertController(title: "Data were chenged!".localized, message: nil, preferredStyle: .ActionSheet)
            let skeepDateAction = UIAlertAction(title: "Close".localized, style: .Cancel, handler: { action in
                self.reloadData()
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
            return super.willFinishOfEditing()
        }
    }
    
    func doneButtonWasPressed() {
        if let theTask = self.task{
            let icons = theTask.icons
            for i in 0..<icons.count{
                var newIconValue = ""
                if i < taskIcons.count{
                    newIconValue = taskIcons[i]
                }
                theTask.setIcon(i, newValue: newIconValue)
            }
        }
        
        super.closeButtonWasPressed()
    }
    
    func fillIconsBuffer() -> [String]{
        if let theTask = self.task{
            let iconsCount = theTask.icons.count
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

    // MARK: UITableViewDataSource

extension SOEditIconsViewController: UITableViewDataSource{
    
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let selectIconsCell = "selectIconsCell"
        let row = indexPath.row
        var cell = self.tableView.dequeueReusableCellWithIdentifier(selectIconsCell) as! SOSelectIconsCell
        
        let ico: SOIco = icons[row]
        let icoId: String = ico.recordid
        
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

    // MARK: UITableViewDelegate

extension SOEditIconsViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let ico: SOIco = icons[row]
        let icoId: String = ico.recordid
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