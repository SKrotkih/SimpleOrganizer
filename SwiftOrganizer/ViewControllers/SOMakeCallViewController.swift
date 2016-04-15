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
        
        rightButton = UIBarButtonItem(title: "Done".localized, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SOMakeCallViewController.doneButtonPressed(_:)))
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
        if phoneNumber!.characters.count > 0{
            if self.emailSwitch.on {
                isValidOk = phoneNumber!.isValidEmail()
            } else {
                isValidOk = phoneNumber!.isValidPhoneNumber()
            }
        }
        if isValidOk {
            if self.faceTimeSwitch.on{
                self.makeCallViaFacetime(phoneNumber!)
            } else {
                self.makeCallViaTelPrompt(phoneNumber!)
            }
        } else {
            let message = "Please enter a valid".localized
            let messageOpt = self.emailSwitch.on ? "e-mail" : "phone number".localized
            showAlertWithTitle("Error".localized, message: "\(message) \(messageOpt)!")
        }
    }
    
    @IBAction func faceTimeSwichChanged(sender: AnyObject) {
        if self.faceTimeSwitch == sender as? UISwitch {
            self.setUpControllsState()
        }
    }
    
    @IBAction func emailSwitchChanged(sender: AnyObject) {
        self.setUpEmailModeState()
    }
}

extension SOMakeCallViewController{

    private func makeCallViaFacetime(phoneNumber: String) {
        let shcheme = "facetime"
        if let URL: NSURL = NSURL(string: "\(shcheme)://\(phoneNumber)") {
            self.openURL(URL)
        }
    }
    
    private func makeCallViaTelPrompt(phoneNumber: String) {
        let shcheme = "telprompt"
        if let URL: NSURL = NSURL(string: "\(shcheme)://\(phoneNumber)") {
            self.openURL(URL)
        }
    }
    
    /// Dial on phone number using the system dialer.
    private func makeCallViaSystemDialer(phoneNumber: String) {
        let shcheme = "tel"
        let sanitizedPhoneNumber = phoneNumber.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet())!
        if let URL: NSURL = NSURL(string: "\(shcheme):\(sanitizedPhoneNumber)") {
            self.openURL(URL)
        }
    }
    
    private func openURL(anURL: NSURL) {
        let application: UIApplication = UIApplication.sharedApplication()
        if (application.canOpenURL(anURL)) {
            application.openURL(anURL);
        }
    }
}

extension SOMakeCallViewController: UITextFieldDelegate{

    func textFieldDidBeginEditing(textField: UITextField){
        self.rightButton.enabled = true
    }
    
}

