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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.userNameLabel.hidden = true
        self.photoImageView.hidden = true
        logOutButton.setTitle("Log In", forState: .Normal)
        self.output.fetchUser()
    }
    
    @IBAction func logOutButtonPressed(sender: AnyObject) {
        let userHasBeenConnected: Bool = LoginWorker.sharedInstance.currentUserHasLoggedIn()
        if userHasBeenConnected{
            self.output.logOut()
        } else {
            self.output.logIn()
        }
    }
}

// MARK: LoginPresenterOutput

extension LoginViewController: LoginPresenterOutput
{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        router.passDataToNextScene(segue)
    }
    
    func displayAboutUserData(userData: Dictionary<String, AnyObject>?){
        let userHasBeenConnected: Bool = LoginWorker.sharedInstance.currentUserHasLoggedIn()
        if userHasBeenConnected{
            logOutButton.setTitle("Log Out", forState: .Normal)
            self.userNameLabel.text = userData["name"]
            self.userNameLabel.hidden = false
            if let photoURLstr: String = userData["photo"]{
                if photoURLstr.compare("") != .OrderedSame{
                    if let photoURL: NSURL = NSURL(string: photoURLstr){
                        self.downloadImage(photoURL) {(data: NSData?) in
                            self.photoImageView.image = UIImage(data: data!)
                            self.photoImageView.hidden = false
                        }
                    }
                }
            }
        } else {
            logOutButton.setTitle("Log In", forState: .Normal)
        }
    }
}

// MARK: Download Image

extension LoginViewController{

    func getDataFromUrl(url:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
    func downloadImage(url: NSURL, completionBlock: (data: NSData?) -> Void){
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                completionBlock(data: data)
            }
        }
    }
}
