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
    @IBOutlet weak var emailSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Call phone via FaceTime".localized
        self.emailSwitch.on = false
    }

    deinit{
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

    @IBAction func callPhoneButtonPressed(sender: AnyObject) {
        
        let phoneNumber = self.phoneNumber.text
        var isValidOk: Bool = false
        
        if count(phoneNumber) > 0{
            if self.emailSwitch.on {
                isValidOk = self.isValidEmail(phoneNumber)
            } else {
                isValidOk = self.isValidPhoneNumber(phoneNumber)
            }
        }
        
        if isValidOk {
            self.facetime(phoneNumber)
        } else {
            let message = "Please enter valid".localized
            let messageOpt = self.emailSwitch.on ? "e-mail" : "phone number".localized
            showAlertWithTitle("Error".localized, "\(message) \(messageOpt)!")
        }
    }
    
    @IBAction func emailSwitchChanged(sender: AnyObject) {
        if self.emailSwitch.on {
            self.phoneNumber.placeholder = "e-mail"
            self.phoneNumber.keyboardType = .EmailAddress
        } else {
            self.phoneNumber.placeholder = "Phone Number".localized
            self.phoneNumber.keyboardType = .PhonePad
        }
    }
    
    private func facetime(phoneNumber: String) {
        if let facetimeURL: NSURL = NSURL(string: "facetime://\(phoneNumber)") {
            let application: UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(facetimeURL)) {
                application.openURL(facetimeURL);
            }
        }
    }
}

    // MARK: Validation e-mail and phonen number

extension SOFaceTimeCallPhoneViewController{
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func isValidPhoneNumber(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let phoneNumberRegEx = "^((\\+)|(00))[0-9]{6,14}$"
        
        let phoneNumberTest = NSPredicate(format:"SELF MATCHES %@", phoneNumberRegEx)
        return phoneNumberTest.evaluateWithObject(testStr)
    }
}
