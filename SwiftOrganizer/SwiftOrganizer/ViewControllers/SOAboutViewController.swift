//
//  SOAboutViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/22/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit



class SOAboutViewController: UIViewController {
    
    weak var delegate: LeftMenuProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "About Autors".localized                
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
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
