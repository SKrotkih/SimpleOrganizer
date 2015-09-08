//
//  SOPreferenceIconsViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 9/3/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOPreferenceIconsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var buffer: [AnyObject] = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Icons".localized
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let rightButtonImage : UIImage! = UIImage(named: "save_task")
        var rightButton: UIBarButtonItem = UIBarButtonItem(image: rightButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonWasPressed")
        navigationItem.rightBarButtonItem = rightButton;
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        
        self.fetchData { () -> Void in
            self.tableView.reloadData()
        }
        
    }
    
    private func didSelectRow(aRow: Int){
        let ico: SOIco = self.buffer[aRow] as! SOIco
        let visible: Bool = !ico.visible
        ico.setVisible(visible, block: {(error: NSError?) in
            if let theError = error{
                showAlertWithTitle("Failed to save data".localized, theError.description)
            } else {
                self.fetchData { () -> Void in
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    private func doneButtonWasPressed(){
        
    }
}

extension SOPreferenceIconsViewController{
    private func fetchData(completeBlock: ()-> Void ){
        SODataFetching.sharedInstance.allIcons{(icons: [SOIco], fetchError: NSError?) in
            if let error = fetchError{
                self.buffer.removeAll(keepCapacity: false)
                showAlertWithTitle("Failed to fetch data".localized, error.description)
            } else {
                self.buffer = icons
                completeBlock()
            }
        }
    }
}

extension SOPreferenceIconsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buffer.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IconsCell") as! SOPreferencesSelectIconsCell
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let ico: SOIco = self.buffer[indexPath.row] as! SOIco

        let icoId: String = ico.recordid
        let icoImageName = ico.imageName;
        cell.icoImageView.image = UIImage(named: icoImageName)
        var checkBoxImageName: String = ico.visible ? "check_box": "uncheck_box"
        cell.checkImageView.image = UIImage(named: checkBoxImageName)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.didSelectRow(indexPath.row)
    }
    
    
}
