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
    @IBOutlet weak var photoImageView: SOBorderedImageView!
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
        self.userNameLabel.hidden = true
        self.photoImageView.hidden = true
        let userHasBeenConnected: Bool = SODataBaseFactory.sharedInstance.dataBase.currentUserHasLoggedIn()
        if userHasBeenConnected{
            logOutButton.setTitle("Log Out", forState: .Normal)
            if let dict = SODataBaseFactory.sharedInstance.dataBase.userInfo(){
                self.userNameLabel.text = dict["name"]
                self.userNameLabel.hidden = false
                if let photoURLstr: String = dict["photo"]{
                    if photoURLstr.compare("") != .OrderedSame{
                        if let photoURL: NSURL = NSURL(string: photoURLstr){
                            self.downloadImage(photoURL) {(data: NSData?) in
                                self.photoImageView.image = UIImage(data: data!)
                                self.photoImageView.hidden = false
                            }
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

extension SOLogInInfoViewController{

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

// MARK: Alert View Controller

extension SOLogInInfoViewController{
    func showAlertWithTitle(title:String, message:String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }
}

