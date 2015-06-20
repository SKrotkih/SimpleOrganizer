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

        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let dataBaseType: String = defaults.stringForKey(SODataBaseType){
            if dataBaseType == SOLocalDataBaseType{
                self.segmentedControl.selectedSegmentIndex = 0
            } else if dataBaseType == SOParseDataBaseType{
                self.segmentedControl.selectedSegmentIndex = 1
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    @IBAction func changeOfDataBase(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let index = self.segmentedControl.selectedSegmentIndex
        
        if index == 0{
            defaults.setObject(SOLocalDataBaseType, forKey: SODataBaseType)
        } else if index == 1{
            defaults.setObject(SOParseDataBaseType, forKey: SODataBaseType)
        }
    }
}