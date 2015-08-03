//
//  SOEnterDescriptionViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOEnterDescriptionViewController: SOEnterBaseViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var heightTextViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Description".localized                        

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification,
            object: nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let rightButtonImage : UIImage! = UIImage(named: "save_task")
        var rightButton: UIBarButtonItem = UIBarButtonItem(image: rightButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonWasPressed")
        navigationItem.rightBarButtonItem = rightButton;

        if let editTask = self.task{
            textView.text = editTask.title
        }
        textView.becomeFirstResponder()
    }
    
    func doneButtonWasPressed() {
        if let editTask = self.task{
            let dict = NSDictionary(objects: [editTask.title], forKeys: ["title"])
            self.undoDelegate?.addToUndoBuffer(dict)
            
            editTask.title = textView.text
        }
        
        super.closeButtonWasPressed()
    }
    
    func keyboardDidShow(notification: NSNotification){
        dispatch_async(dispatch_get_main_queue(), {
            if let userInfo = notification.userInfo {
                if let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size {
                    let keyboardHeight: CGFloat = keyboardSize.height
                    let textViewHeight = CGRectGetHeight(self.view.frame) - (CGRectGetMinY(self.textView.frame) + 16.0 + keyboardHeight)
                    self.heightTextViewConstraint.constant = textViewHeight
                    self.textView.layoutIfNeeded()
                }
            }
        })
    }
}
