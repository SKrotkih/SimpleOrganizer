//
//  SOLogInInfoViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 10/7/15.
//  Copyright © 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOLogInInfoViewController: UIViewController {
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    override func viewDidLoad() {
        
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.fillContent()
    }
    
    @IBAction func logOutButtonPressed(sender: AnyObject) {
        let userHasBeenConnected: Bool = SODataBaseFactory.sharedInstance.dataBase.currentUserHasLoggedIn()
        if userHasBeenConnected{
            SODataBaseFactory.sharedInstance.dataBase.logOut(self, completionBlock: { (error) -> Void in
                if let theError = error{
                    self.showAlertWithTitle("Failed log out to Parse.com!", message: "\(theError.localizedDescription)")
                } else {
                    self.fillContent()
                }
            })
        } else {
            SODataBaseFactory.sharedInstance.dataBase.logIn(self, completionBlock: { (error: NSError?) -> Void in
                if let theError = error{
                    self.showAlertWithTitle("Failed log in to Parse.com!", message: "\(theError.localizedDescription)")
                } else {
                    self.fillContent()
                }
            })
        }
    }
    
    private func fillContent(){
        let userHasBeenConnected: Bool = SODataBaseFactory.sharedInstance.dataBase.currentUserHasLoggedIn()
        if userHasBeenConnected{
            logOutButton.setTitle("Log Out", forState: .Normal)
            
            if let dict = SODataBaseFactory.sharedInstance.dataBase.userInfo(){
                self.userNameLabel.text = dict["name"]
                self.userNameLabel.hidden = false
            } else {
                self.userNameLabel.hidden = true
            }
        } else {
            logOutButton.setTitle("Log In", forState: .Normal)
            self.userNameLabel.hidden = true
        }
    }
    
}


// MARK: Alert View Controller

extension SOLogInInfoViewController{
    func showAlertWithTitle(title:String, message:String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }
}

