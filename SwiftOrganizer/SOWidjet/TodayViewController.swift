//
//  TodayViewController.swift
//  Widget
//
//  Created by vandad on 167//14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit
import NotificationCenter
import DataBaseKit

class TodayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,  NCWidgetProviding {

    @IBOutlet weak var typeOfDataBaseSwitcher: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    /* The same identifier is saved in our storyboard for the prototype
    cells for this table view controller */
    struct TableViewConstants{
        static let cellIdentifier = "taskcellid"
        static let cellHeight: CGFloat = 32.0
    }
    
    /* List of items that we want to display in our table view */
    private var icons = [SOIco]()

    // MARK: UITableViewDelegate, UITableViewDataSource delegate protocol
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.icons.count
    }
    
    func tableView(tableView: UITableView,  heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return TableViewConstants.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewConstants.cellIdentifier, forIndexPath: indexPath) as! SOWidgetTableViewCell
        let row = indexPath.row
        let ico: SOIco = self.icons[row]
        let icoName = ico.name
        cell.descriptionLabel!.text = icoName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let urlAsString = "widget://" + "\(indexPath.section)-\(indexPath.row)"
        let url = NSURL(string: urlAsString)
        self.extensionContext!.openURL(url!, completionHandler: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    // MARK: -

    @IBAction func switchToAnotherDataBase(sender: AnyObject) {
        let index = typeOfDataBaseSwitcher.selectedSegmentIndex
        SOTypeDataBaseSwitcher.switchToIndex(index)

        let urlAsString = "widget://\(KeyInURLAsSwitchDataBase)\(index)"
        let url = NSURL(string: urlAsString)
        self.extensionContext!.openURL(url!, completionHandler: nil)
    }
    
    func resetContentSize(){
        var prefferedSize: CGSize = tableView.contentSize
        prefferedSize.height = CGRectGetMaxY(self.typeOfDataBaseSwitcher.frame)
        prefferedSize.height += 15.0
        prefferedSize.height += CGFloat(self.icons.count) * TableViewConstants.cellHeight
        
        self.preferredContentSize = prefferedSize
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let index = SOTypeDataBaseSwitcher.indexOfCurrectDBType()
        self.typeOfDataBaseSwitcher.selectedSegmentIndex = index
        
        self.performFetch()
    }
    
    func performFetch() -> NCUpdateResult {
        SODataFetching.sharedInstance.allIcons{(icons: [SOIco], fetchError: NSError?) in
            if let error = fetchError{
                println("Error reading icons data \(error.description)")
                self.icons.removeAll(keepCapacity: true)
            } else {
                self.icons = icons
                self.tableView.reloadData()
                self.resetContentSize()
            }
        }
        
        return .NewData
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        let result = performFetch()
        completionHandler(result)
    }
    
}
