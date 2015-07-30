//
//  SOSettingsViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOFaceTimeCallPhoneViewController: UIViewController {
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Call phone via FaceTime".localized
        
    }

    deinit{
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

    @IBAction func callPhoneButtonPressed(sender: AnyObject) {
        
        let phoneNumber = self.phoneNumber.text
        self.facetime(phoneNumber)
        
    }
    
    private func facetime(phoneNumber:String) {
        if let facetimeURL:NSURL = NSURL(string: "facetime://\(phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(facetimeURL)) {
                application.openURL(facetimeURL);
            }
        }
    }
    
    
}
