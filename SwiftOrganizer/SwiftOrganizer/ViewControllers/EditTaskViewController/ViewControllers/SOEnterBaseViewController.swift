//
//  SOEnterBaseViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOEnterBaseViewController: UIViewController {

    var task: SOTask?
    var undoDelegate: SOEditTaskUndoDelegateProtocol?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let leftButtonImage: UIImage! = UIImage(named: "back_button")
        var leftButton: UIBarButtonItem = UIBarButtonItem(image: leftButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: "closeButtonWasPressed")
        navigationItem.leftBarButtonItem = leftButton;
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }

    func closeButtonWasPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
