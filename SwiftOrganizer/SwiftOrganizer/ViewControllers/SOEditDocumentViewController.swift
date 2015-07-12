//
//  SOEditDocumentViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 7/12/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//


import UIKit

class SOEditDocumentViewController: UIViewController, UITextViewDelegate {
    
    var rightButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        rightButton = UIBarButtonItem(title: "Done".localized, style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonPressed:")
        navigationItem.rightBarButtonItem = rightButton;
        
        self.textView.becomeFirstResponder()
    }

    func configureView() {
        if let document: SOSampleDocument = self.detailItem {
            self.textView?.text = document.text
        }
    }
    
    var detailItem: SOSampleDocument? {
        didSet {
            self.configureView()
        }
    }
    
    func textViewDidChange(textView: UITextView) { //Handle the text changes here
        if let document : SOSampleDocument = self.detailItem {
            document.text = self.textView.text
            document.updateChangeCount(UIDocumentChangeKind.Done)
        }
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject){
        if let document: SOSampleDocument = self.detailItem {
            document.saveToURL(document.fileURL, forSaveOperation: UIDocumentSaveOperation.ForOverwriting){(success) in
                self.navigationController?.popViewControllerAnimated(true)
                
                return
            }
        }
    }
}

