//
//  SOAboutViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit



class SOAboutViewController: UIViewController {
    
    weak var delegate: LeftMenuProtocol?
    @IBOutlet weak var readmeTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "About SwiftOrganizer".localized
        
        let readmeFilePath = NSBundle.mainBundle().pathForResource("README", ofType: "md")

        if let readme = NSString(contentsOfFile: readmeFilePath!, encoding: NSUTF8StringEncoding, error: nil){
            self.readmeTextView.text = readme as String
        } else {
            self.readmeTextView.text = ""
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        if let viewController = self.slideMenuController()?.mainViewController as? UINavigationController {
            if viewController.topViewController.isKindOfClass(SOAboutViewController) {
                self.slideMenuController()?.removeLeftGestures()
                self.slideMenuController()?.removeRightGestures()
            }
        }
    }
    
    @IBAction func didTouchToMain(sender: UIButton) {
        delegate?.changeViewController(LeftMenu.Main)
    }
}
