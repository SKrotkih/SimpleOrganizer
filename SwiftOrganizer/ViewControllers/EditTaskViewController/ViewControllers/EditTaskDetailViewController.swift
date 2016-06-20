//
//  EditTaskDetailViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import DataBaseKit

class EditTaskDetailViewController: UIViewController {
    
    var delegate: DetailsViewControllerDelegate?
    var undoDelegate: SOEditTaskUndoDelegateProtocol?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let leftButtonImage: UIImage! = UIImage(named: "back_button")
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: leftButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditTaskDetailViewController.closeButtonWasPressed))
        navigationItem.leftBarButtonItem = leftButton;
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    func willFinishEditing() -> Bool{
        return true
    }
    
    func closeButtonWasPressed() {
        if self.willFinishEditing(){
            self.performSegueWithIdentifier("unwindToEditTaskViewController", sender: self)
        }
    }
}
