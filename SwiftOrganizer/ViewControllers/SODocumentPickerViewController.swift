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
        rightButton = UIBarButtonItem(title: "Open".localized, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SODocumentPickerViewController.importAction(_:)))
        navigationItem.rightBarButtonItem = rightButton;
    }

    func importAction(sender: AnyObject) {
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], inMode: UIDocumentPickerMode.Import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        self.presentViewController(documentPicker, animated: true, completion: nil)
    }

    func URLForDocuments() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }

    func saveFileToDocuments(srcFileNameURL: NSURL, dstFileName: String)
    {
        var destinationURL = URLForDocuments()
        destinationURL = destinationURL.URLByAppendingPathComponent(dstFileName)
        var copyError : NSError? = nil
        do {
            try NSFileManager.defaultManager().copyItemAtURL(srcFileNameURL, toURL: destinationURL)
        } catch let error as NSError {
            copyError = error
        }
        
        if let theError = copyError {
            print("Error making ubiquitous: \(theError)")
        }
    }
    
    func saveFileToiCloud(srcFileNameURL: NSURL, dstFileName: String)
    {
        let destinationURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)?.URLByAppendingPathComponent("Documents").URLByAppendingPathComponent(dstFileName)
        var makeUbiquitousError : NSError? = nil
        do {
            try NSFileManager.defaultManager().setUbiquitous(true, itemAtURL: srcFileNameURL, destinationURL: destinationURL!)
        } catch let error as NSError {
            makeUbiquitousError = error
        }
        
        if let theError = makeUbiquitousError {
            print("Error making ubiquitous: \(theError)")
        }
    }
}

    // MARK: - UIDocumentPickerDelegate

extension SODocumentPickerViewController: UIDocumentPickerDelegate{
    
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        
        let fileName = url.lastPathComponent
        let temporaryURL = NSURL.fileURLWithPath(NSTemporaryDirectory(), isDirectory:true).URLByAppendingPathComponent(fileName!)
        var copyFileError : NSError? = nil

        do {
            try NSFileManager.defaultManager().copyItemAtURL(url, toURL: temporaryURL)
        } catch let error as NSError {
            copyFileError = error
        }
        
        if let theError = copyFileError {
            print("Error copying: \(theError)")
        }
        self.saveFileToDocuments(temporaryURL, dstFileName: fileName!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func documentPickerWasCancelled(controller: UIDocumentPickerViewController)
    {
        // Nothing got selected, so just dismiss it
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
