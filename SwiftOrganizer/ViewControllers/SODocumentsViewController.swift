//
//  SODocumentsViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SODocumentsViewController: UITableViewController {
    var rightButton: UIBarButtonItem!
    var txtFiles: [NSURL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Documents".localized
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        rightButton = UIBarButtonItem(title: "Add".localized, style: UIBarButtonItemStyle.Plain, target: self, action: "createDocument:")
        navigationItem.rightBarButtonItem = rightButton;
        
        self.updateFileList()
    }
    
    func URLForDocuments() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }
    
    func updateFileList() {
        if let directoryUrls: [NSURL] =  try? NSFileManager.defaultManager().contentsOfDirectoryAtURL(self.URLForDocuments(), includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants) {
            self.txtFiles = directoryUrls.filter(){$0.pathExtension == "txt" || $0.pathExtension == "pdf"}
            self.tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showDetail" {
            let detailViewController = segue.destinationViewController as! SOEditDocumentViewController

            if let document = sender as? SOSampleDocument{
                detailViewController.detailItem = document
            }
        }
    }
    
    @IBAction func createDocument(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.stringFromDate(NSDate())
        let fileName = "Document \(dateString).txt"
        let url = self.URLForDocuments().URLByAppendingPathComponent(fileName)
        let documentToCreate = SOSampleDocument(fileURL: url)
        
        documentToCreate.saveToURL(url, forSaveOperation: UIDocumentSaveOperation.ForCreating) {(success) in
            if success == true {
                self.performSegueWithIdentifier("showDetail", sender: documentToCreate)
            }
        }
    }
    
}

    // MARK: - TableView Delegate and DataSource protocol implementation

extension SODocumentsViewController{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.txtFiles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FileCell")
        let filePath = self.txtFiles[indexPath.row]
        //let fileURL: NSURL! = NSURL(fileURLWithPath: filePath)
        cell!.textLabel?.text = filePath.lastPathComponent
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let filePath = self.txtFiles[indexPath.row]
        //let fileURL: NSURL! = NSURL(fileURLWithPath: filePath)
        let documentToOpen = SOSampleDocument(fileURL: filePath)
        
        documentToOpen.openWithCompletionHandler() { (success) in
            if success == true {
                self.performSegueWithIdentifier("showDetail", sender: documentToOpen)
            }
        }
    }
}
