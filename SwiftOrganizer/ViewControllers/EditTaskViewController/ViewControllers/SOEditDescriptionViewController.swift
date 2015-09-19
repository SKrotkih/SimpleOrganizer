//
//  SOEditDescriptionViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOEditDescriptionViewController: SOEditTaskFieldBaseViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var heightTextViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Description".localized                        

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification,  object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let rightButtonImage : UIImage! = UIImage(named: "save_task")
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: rightButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonWasPressed")
        navigationItem.rightBarButtonItem = rightButton;

        self.automaticallyAdjustsScrollViewInsets = false
        textView.text = self.task?.title

        textView.becomeFirstResponder()
    }
    
    override func willFinishEditing() -> Bool{
        if let theTask = self.task{
            if theTask.title != textView.text{
                let controller = UIAlertController(title: "Data were chenged!".localized, message: nil, preferredStyle: .ActionSheet)
                let skeepDateAction = UIAlertAction(title: "Discard".localized, style: .Cancel, handler: { action in
                    self.textView.text = self.task?.title
                    super.closeButtonWasPressed()
                })
                let saveDateAction = UIAlertAction(title: "Save".localized, style: .Default, handler: { action in
                    self.doneButtonWasPressed()
                })
                controller.addAction(skeepDateAction)
                controller.addAction(saveDateAction)
                self.presentViewController(controller, animated: true, completion: nil)
                
                return false
            }
        }
        
        return super.willFinishEditing()
    }
    
    func doneButtonWasPressed() {
        if let theTask = self.task{
            let dict = NSDictionary(objects: [theTask.title], forKeys: ["title"])
            self.undoDelegate?.addToUndoBuffer(dict)
            
            theTask.title = textView.text
        }
        
        super.closeButtonWasPressed()
    }
    
    func keyboardDidShow(notification: NSNotification){
        dispatch_async(dispatch_get_main_queue(), {
            if let userInfo = notification.userInfo {
                if let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size {
                    let keyboardHeight: CGFloat = keyboardSize.height
                    let textViewHeight = CGRectGetHeight(self.view.frame) - (CGRectGetMinY(self.textView.frame) + 16.0 + keyboardHeight)
                    self.heightTextViewConstraint.constant = textViewHeight
                    self.textView.layoutIfNeeded()
                }
            }
        })
    }
}
