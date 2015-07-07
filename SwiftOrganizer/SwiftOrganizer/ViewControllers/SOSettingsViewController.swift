//
//  SOSettingsViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOSettingsViewController: UIViewController, SOObserverProtocol {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var useiCloudSwitch: UISwitch!
    
    deinit{
        SOObserversManager.sharedInstance.removeObserver(self, type: .SODataBaseTypeChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings".localized
        self.setUpCurrentDataBaseType()
        
        SOObserversManager.sharedInstance.addObserver(self, type: .SODataBaseTypeChanged)
    }
    
    private func setUpCurrentDataBaseType()
    {
        var selectedIndex: Int!
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let name = defaults.stringForKey(SODataBaseTypeKey){
            switch name{
            case SODataBaseType.CoreData.rawValue:
                selectedIndex = 0
                let useiCloudOpt: Bool? = defaults.boolForKey(SOEnableiCloudForCoreDataKey)

                if let useiCloud = useiCloudOpt{
                    self.useiCloudSwitch.on = useiCloud
                } else {
                    self.useiCloudSwitch.on = false
                }
                self.useiCloudSwitch.enabled = true
            case SODataBaseType.ParseCom.rawValue:
                selectedIndex = 1
                self.useiCloudSwitch.enabled = false
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
        var dbType: String

        if index == 0{
            dbType = SODataBaseType.CoreData.rawValue
        } else if index == 1{
            dbType = SODataBaseType.ParseCom.rawValue
        } else {
            return
        }
        
        defaults.setObject(dbType, forKey: SODataBaseTypeKey)
        defaults.synchronize()
        let notification: SOObserverNotification = SOObserverNotification(type: .SODataBaseTypeChanged, data: dbType)
        SOObserversManager.sharedInstance.sendNotification(notification)
    }
    
    @IBAction func changeOfUsingiCloud(sender: AnyObject) {
        let useiCloudValue = self.useiCloudSwitch.on
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(useiCloudValue, forKey: SOEnableiCloudForCoreDataKey)
        defaults.synchronize()
    }
    
    //- MARK: SOObserverProtocol implementation
    func notify(notification: SOObserverNotification){
        switch notification.type{
        case .SODataBaseTypeChanged:
            setUpCurrentDataBaseType()            
        default:
            assert(false, "The observer code notification is wrong!")
        }
    }
    
}
