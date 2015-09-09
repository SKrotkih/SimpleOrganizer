//
//  SOMakeCallViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 7/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOMakeCallViewController: UIViewController {

    var rightButton: UIBarButtonItem!
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var emailSwitch: UISwitch!
    @IBOutlet weak var faceTimeSwitch: UISwitch!
    @IBOutlet weak var titleOfTextFieldLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Make Call".localized
        self.emailSwitch.on = false
        self.faceTimeSwitch.on = false
        self.phoneNumber.delegate = self
        self.setUpControllsState()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        
        rightButton = UIBarButtonItem(title: "Done".localized, style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonPressed:")
        navigationItem.rightBarButtonItem = rightButton;
        self.phoneNumber.resignFirstResponder()
        self.rightButton.enabled = false
        
    }

    deinit{
    }
    
    func doneButtonPressed(sender: AnyObject) {
        self.phoneNumber.resignFirstResponder()
        self.rightButton.enabled = false
    }

    func setUpControllsState() {
        if self.faceTimeSwitch.on {
            self.titleOfTextFieldLabel.text = "Please enter a phone number or e-mail:".localized
            self.emailSwitch.enabled = true
            self.emailSwitch.on = false
            self.setUpEmailModeState()
        } else {
            self.titleOfTextFieldLabel.text = "Please enter a phone number".localized
            self.emailSwitch.enabled = false
            self.phoneNumber.placeholder = "Phone Number".localized
        }
    }
    
    func setUpEmailModeState() {
        if self.emailSwitch.on {
            self.phoneNumber.placeholder = "e-mail"
            self.phoneNumber.keyboardType = .EmailAddress
        } else {
            self.phoneNumber.placeholder = "Phone Number".localized
            self.phoneNumber.keyboardType = .PhonePad
        }
    }
    
    
    @IBAction func callPhoneButtonPressed(sender: AnyObject) {
        
        let phoneNumber = self.phoneNumber.text
        var isValidOk: Bool = false
        
        if count(phoneNumber) > 0{
            if self.emailSwitch.on {
                isValidOk = phoneNumber.isValidEmail()
            } else {
                isValidOk = phoneNumber.isValidPhoneNumber()
            }
        }
        
        if isValidOk {
            self.facetime(phoneNumber)
        } else {
            let message = "Please enter a valid".localized
            let messageOpt = self.emailSwitch.on ? "e-mail" : "phone number".localized
            showAlertWithTitle("Error".localized, "\(message) \(messageOpt)!")
        }
    }
    
    @IBAction func faceTimeSwichChanged(sender: AnyObject) {
        if let switchFaceTime = sender as? UISwitch{
            self.setUpControllsState()
        }
    }
    
    @IBAction func emailSwitchChanged(sender: AnyObject) {
        self.setUpEmailModeState()
    }
    
    private func facetime(phoneNumber: String) {
        let shcheme: String = self.faceTimeSwitch.on ? "facetime" : "telprompt"
        
        if let facetimeURL: NSURL = NSURL(string: "\(shcheme)://\(phoneNumber)") {
            let application: UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(facetimeURL)) {
                application.openURL(facetimeURL);
            }
        }
    }
}

extension SOMakeCallViewController: UITextFieldDelegate{

    func textFieldDidBeginEditing(textField: UITextField){
        self.rightButton.enabled = true
    }
    
}

