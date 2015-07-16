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
        let selectedIndex = SOTypeDataBaseSwitcher.indexOfCurrectDBType()
        let usingICloud = SOTypeDataBaseSwitcher.usingICloudCurrentState()

        if selectedIndex == 0{
            self.useiCloudSwitch.on = usingICloud
            self.useiCloudSwitch.enabled = true
        } else if selectedIndex == 1{
            self.useiCloudSwitch.enabled = false
        }
        self.segmentedControl.selectedSegmentIndex = selectedIndex
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    @IBAction func changeOfDataBase(sender: AnyObject) {
        let index = self.segmentedControl.selectedSegmentIndex
        SOTypeDataBaseSwitcher.switchToIndex(index)
    }
    
    @IBAction func changeOfUsingiCloud(sender: AnyObject) {
        let useiCloudValue = self.useiCloudSwitch.on
        SOTypeDataBaseSwitcher.setUpOfUsingICloud(useiCloudValue)
    }
    
    //- MARK: SOObserverProtocol implementation
    func notify(notification: SOObserverNotification){
        switch notification.type{
        case .SODataBaseTypeChanged:
            setUpCurrentDataBaseType()            
        default:
            assert(false, "Something is wrong with observer code notification!")
        }
    }
}
