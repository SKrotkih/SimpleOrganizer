//
//  SOSettingsViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOSettingsViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings".localized
        self.setUpCurrentDataBaseType()
    }
    
    private func setUpCurrentDataBaseType()
    {
        var selectedIndex: Int!
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let name = defaults.stringForKey(SODataBaseTypeKey){
            switch name{
            case SODataBaseType.CoreData.rawValue:
                selectedIndex = 0
            case SODataBaseType.ParseCom.rawValue:
                selectedIndex = 1
            default:
                selectedIndex = 0
            }
        } else {
            selectedIndex = 0
        }

        self.segmentedControl.selectedSegmentIndex = selectedIndex
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    @IBAction func changeOfDataBase(sender: AnyObject) {
        let index = self.segmentedControl.selectedSegmentIndex
        
        let defaults = NSUserDefaults.standardUserDefaults()

        if index == 0{
            defaults.setObject(SODataBaseType.CoreData.rawValue, forKey: SODataBaseTypeKey)
        } else if index == 1{
            defaults.setObject(SODataBaseType.ParseCom.rawValue, forKey: SODataBaseTypeKey)
        }
        
        let notification: SOObserverNotification = SOObserverNotification(type: .SODataBaseTypeChanged, data: nil)
        SOObserversManager.sharedInstance.sendNotification(notification)
    }
}
