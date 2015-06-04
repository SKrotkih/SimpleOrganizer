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

    var icons: [Ico]!
    var taskIcons: [String]! = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        icons = SOLocalDataBase.sharedInstance.allIcons
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let rightButtonImage : UIImage! = UIImage(named: "save_task")
        var rightButton: UIBarButtonItem = UIBarButtonItem(image: rightButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonWasPressed")
        navigationItem.rightBarButtonItem = rightButton;
        
        if let editTask = self.task{
            let icons: [String] = [editTask._ico1, editTask._ico2,editTask._ico3,editTask._ico4,editTask._ico5,editTask._ico6]
            taskIcons.removeAll(keepCapacity: false)
            for i in 0..<icons.count{
                if icons[i] != ""{
                    taskIcons.append(icons[i])
                }
            }
        }
    }
    
    func doneButtonWasPressed() {
        if let editTask = self.task{
            editTask._ico1 = ""
            editTask._ico2 = ""
            editTask._ico3 = ""
            editTask._ico4 = ""
            editTask._ico5 = ""
            editTask._ico6 = ""
            
            for i in 0..<taskIcons.count{
                switch i{
                case 0: editTask._ico1 = taskIcons[0]
                case 1: editTask._ico2 = taskIcons[1]
                case 2: editTask._ico3 = taskIcons[2]
                case 3: editTask._ico4 = taskIcons[3]
                case 4: editTask._ico5 = taskIcons[4]
                case 5: editTask._ico6 = taskIcons[5]
                default: break
                }
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
    
    // Customizing the row height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) ->
        CGFloat {
            return 44
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let selectIconsCell = "selectIconsCell"
        let row = indexPath.row
        var cell = self.tableView.dequeueReusableCellWithIdentifier(selectIconsCell) as! SOSelectIconsCell

        let ico: Ico = icons[row]
        let icoId: String = ico.id
        let icoImageName = SOLocalDataBase.sharedInstance.iconsImageName(icoId)
        cell.icoImageView.image = UIImage(named: icoImageName)
        
        var imageName: String = "uncheck_box"
        
        for i in 0..<taskIcons.count{
            if icoId == taskIcons[i]{
                imageName =  "check_box"

                break
            }
        }
        cell.checkImageView.image = UIImage(named: imageName)
        
        return cell
    }
    
    //- MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let ico: Ico = icons[row]
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
