//
//  SOEditTaskFieldBaseViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import DataBaseKit

class SOEditTaskFieldBaseViewController: UIViewController {
    
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
    
    func willFinishOfEditing() -> Bool{
        return true
    }
    
    func closeButtonWasPressed() {
        if self.willFinishOfEditing(){
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
