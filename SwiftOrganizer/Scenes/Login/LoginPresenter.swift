//
//  LoginPresenter.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/12/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import UIKit
import DataBaseKit

protocol LoginPresenterOutput: class
{
    func displayAboutUserData(userData: Dictionary<String, AnyObject>?)
}

protocol LoginInteractorOutput {
    func presentFetchedUser(user: User?)
}

class LoginPresenter: LoginInteractorOutput {
    
    weak var output: LoginPresenterOutput!
    
    func presentFetchedUser(user: User?){
        if let currentUser: User = user  {
            if let photoURLstr: String = currentUser.photo_prefix{
                if photoURLstr.compare("") != .OrderedSame{
                    if let photoURL: NSURL = NSURL(string: photoURLstr){
                        self.downloadImage(photoURL) {[weak self](data: NSData?) in
                            if let imageData = data{
                                if let photo: UIImage = UIImage(data: imageData){
                                    let dict: Dictionary<String, AnyObject> = ["name": currentUser.name, "photo": photo]
                                    self?.output.displayAboutUserData(dict)
                                    return
                                }
                            }
                        }
                    }
                }
            }
            let dict: Dictionary<String, AnyObject> = ["name": currentUser.name]
            output.displayAboutUserData(dict)
        } else {
            output.displayAboutUserData(nil)
        }
    }
    
}

// MARK: Download Image

extension LoginPresenter{
    
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
