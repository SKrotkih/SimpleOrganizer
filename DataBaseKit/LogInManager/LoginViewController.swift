//
//  LoginViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 10/7/15.
//  Copyright © 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

protocol LoginViewControllerOutput
{
    func fetchUser()
    func logIn()
    func logOut()
    var user: User? { get }
}

class LoginViewController: UIViewController {
    var output: LoginViewControllerOutput!
    var router: LoginRouter!

    var loggedIn: Bool = false
    var userData: Dictionary<String, AnyObject>?
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var photoImageView: SOBorderedImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        LoginConfigurator.sharedInstance.configure(self)
    }

    override func viewDidLoad() {
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        displayLogInScreen()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.output.fetchUser()
    }
    
    @IBAction func logOutButtonPressed(sender: AnyObject) {
        if self.loggedIn{
            self.output.logOut()
        } else {
            self.output.logIn()
        }
    }
    
    func displayLogInScreen(){
        dispatch_async(dispatch_get_main_queue(), {
            self.userNameLabel.hidden = true
            self.photoImageView.hidden = true
            self.photoImageView.image = nil
            self.logOutButton.setTitle("Log In", forState: .Normal)
        })
    }
    
    func displayLogOutScreen(){
        dispatch_async(dispatch_get_main_queue(), {
            self.logOutButton.setTitle("Log Out", forState: .Normal)
            self.userNameLabel.text = self.userData!["name"] as? String
            self.userNameLabel.hidden = false
            if let photo: UIImage = self.userData!["photo"] as? UIImage{
                self.photoImageView.image = photo
                self.photoImageView.hidden = false
            }
        })
    }
    
}

// MARK: LoginPresenterOutput

extension LoginViewController: LoginPresenterOutput
{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        router.passDataToNextScene(segue)
    }
    
    func displayFetchedUserData(userData: Dictionary<String, AnyObject>?){
        self.userData = userData
        self.loggedIn = self.userData != nil
        if self.loggedIn{
            displayLogOutScreen()
        } else {
            displayLogInScreen()
        }
    }
}
