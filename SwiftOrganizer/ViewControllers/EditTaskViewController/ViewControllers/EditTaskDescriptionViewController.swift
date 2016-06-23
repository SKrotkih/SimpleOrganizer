//
//  EditTaskDescriptionViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class EditTaskDescriptionViewController: EditTaskDetailViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var heightTextViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Description".localized                        

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditTaskDescriptionViewController.keyboardDidShow(_:)), name: UIKeyboardDidShowNotification,  object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let rightButtonImage : UIImage! = UIImage(named: "save_task")
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: rightButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditTaskDescriptionViewController.doneButtonWasPressed))
        navigationItem.rightBarButtonItem = rightButton;

        self.automaticallyAdjustsScrollViewInsets = false
        
        textView.text = input.task.title

        textView.becomeFirstResponder()
    }
    
    override func willFinishEditing() -> Bool{
            if input.task.title != textView.text{
                let controller = UIAlertController(title: "Data was chenged!".localized, message: nil, preferredStyle: .ActionSheet)
                let skeepDateAction = UIAlertAction(title: "Discard".localized, style: .Cancel, handler: { action in
                    self.textView.text = self.input.task.title
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
        
        return super.willFinishEditing()
    }
    
    func doneButtonWasPressed() {
        let dict = NSDictionary(objects: [self.input.task.title], forKeys: ["title"])
        self.undoDelegate?.addToUndoBuffer(dict)
        
        self.input.task.title = textView.text
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
