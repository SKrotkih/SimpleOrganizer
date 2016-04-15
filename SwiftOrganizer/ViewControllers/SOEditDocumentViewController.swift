//
//  SOEditDocumentViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 7/12/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//


import UIKit

class SOEditDocumentViewController: UIViewController {
    
    var rightButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        rightButton = UIBarButtonItem(title: "Done".localized, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SOEditDocumentViewController.doneButtonPressed(_:)))
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
    
    @IBAction func doneButtonPressed(sender: AnyObject){
        if let document: SOSampleDocument = self.detailItem {
            document.saveToURL(document.fileURL, forSaveOperation: UIDocumentSaveOperation.ForOverwriting){(success) in
                self.navigationController?.popViewControllerAnimated(true)
                
                return
            }
        }
    }
}

extension SOEditDocumentViewController: UITextViewDelegate{
    
    func textViewDidChange(textView: UITextView) {
        if let document : SOSampleDocument = self.detailItem {
            //Handle the text changes here
            document.text = self.textView.text
            document.updateChangeCount(UIDocumentChangeKind.Done)
        }
    }
    
}
