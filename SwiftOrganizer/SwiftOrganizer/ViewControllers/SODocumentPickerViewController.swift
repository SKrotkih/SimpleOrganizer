//
//  SODocumentPickerViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SODocumentPickerViewController: UIViewController {
    var rightButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "External Documents".localized
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        
        let buttonImage : UIImage! = UIImage(named: "add_task")
        rightButton = UIBarButtonItem(title: "Open".localized, style: UIBarButtonItemStyle.Plain, target: self, action: "importAction:")
        navigationItem.rightBarButtonItem = rightButton;
    }

    func importAction(sender: AnyObject) {
        var documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], inMode: UIDocumentPickerMode.Import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        self.presentViewController(documentPicker, animated: true, completion: nil)
    }

    func URLForDocuments() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last as! NSURL
    }

    func saveFileToDocuments(srcFileNameURL: NSURL, dstFileName: String)
    {
        var destinationURL = URLForDocuments()
        destinationURL = destinationURL.URLByAppendingPathComponent(dstFileName)
        var copyError : NSError? = nil
        NSFileManager.defaultManager().copyItemAtURL(srcFileNameURL, toURL: destinationURL, error: &copyError)
        
        if let theError = copyError {
            println("Error making ubiquitous: \(theError)")
        }
    }
    
    func saveFileToiCloud(srcFileNameURL: NSURL, dstFileName: String)
    {
        let destinationURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)?.URLByAppendingPathComponent("Documents").URLByAppendingPathComponent(dstFileName)
        var makeUbiquitousError : NSError? = nil
        NSFileManager.defaultManager().setUbiquitous(true, itemAtURL: srcFileNameURL, destinationURL: destinationURL!, error: &makeUbiquitousError)
        
        if let theError = makeUbiquitousError {
            println("Error making ubiquitous: \(theError)")
        }
    }
}

    // MARK: - UIDocumentPickerDelegate

extension SODocumentPickerViewController: UIDocumentPickerDelegate{
    
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        
        let fileName = url.lastPathComponent
        let temporaryURL = NSURL.fileURLWithPath(NSTemporaryDirectory(), isDirectory:true)?.URLByAppendingPathComponent(fileName!)
        var copyError : NSError? = nil
        NSFileManager.defaultManager().copyItemAtURL(url, toURL: temporaryURL!, error: &copyError)
        
        if let theError = copyError {
            println("Error copying: \(theError)")
        }
        self.saveFileToDocuments(temporaryURL!, dstFileName: fileName!)
        //self.saveFileToiCloud(temporaryURL!, dstFileName: fileName!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func documentPickerWasCancelled(controller: UIDocumentPickerViewController)
    {
        // Nothing got selected, so just dismiss it
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
