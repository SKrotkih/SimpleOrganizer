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
    @IBOutlet weak var useiCloudSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings".localized
        self.setUpCurrentDataBaseType()
        
        SOObserversManager.sharedInstance.addObserver(self, type: .SODataBaseTypeChanged)
    }

    deinit{
        SOObserversManager.sharedInstance.removeObserver(self, type: .SODataBaseTypeChanged)
    }
    
    private func setUpCurrentDataBaseType()
    {
        let selectedIndex = SOTypeDataBaseSwitcher.currentDataBaseIndex()
        let usingICloud = SOTypeDataBaseSwitcher.usingICloudCurrentState()

        if selectedIndex == .CoreDataIndex{
            self.useiCloudSwitch.on = usingICloud
            self.useiCloudSwitch.enabled = true
        } else if selectedIndex == .ParseComIndex{
            self.useiCloudSwitch.enabled = false
        }
        self.segmentedControl.selectedSegmentIndex = selectedIndex.rawValue
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    @IBAction func changeOfDataBase(sender: AnyObject) {
        let index = self.segmentedControl.selectedSegmentIndex
        SOTypeDataBaseSwitcher.switchToIndex(DataBaseIndex(rawValue: index)!)
    }
    
    @IBAction func changeOfUsingiCloud(sender: AnyObject) {
        let useiCloudValue = self.useiCloudSwitch.on
        SOTypeDataBaseSwitcher.setUpOfUsingICloud(useiCloudValue)
    }
}

extension SOSettingsViewController: SOObserverProtocol{
    func notify(notification: SOObserverNotification){
        switch notification.type{
        case .SODataBaseTypeChanged:
            setUpCurrentDataBaseType()
        default:
            assert(false, "Something is wrong with observer code notification!")
        }
    }
}

