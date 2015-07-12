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
    var txtFiles: [String!] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Documents".localized
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        
        let buttonImage : UIImage! = UIImage(named: "add_task")
        rightButton = UIBarButtonItem(title: "Add".localized, style: UIBarButtonItemStyle.Plain, target: self, action: "createDocument:")
        navigationItem.rightBarButtonItem = rightButton;
        
        self.updateFileList()
    }
    
    func URLForDocuments() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last as! NSURL
    }
    
    func updateFileList() {
        if let directoryUrls =  NSFileManager.defaultManager().contentsOfDirectoryAtURL(self.URLForDocuments(), includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants, error: nil) {
            self.txtFiles = directoryUrls.map(){ $0.path }.filter(){ $0.pathExtension == "txt" }
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.txtFiles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FileCell") as! UITableViewCell
        let filePath = self.txtFiles[indexPath.row]
        cell.textLabel?.text = filePath.lastPathComponent
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let filePath = self.txtFiles[indexPath.row]
        let URL: NSURL! = NSURL(fileURLWithPath: filePath)
        let documentToOpen = SOSampleDocument(fileURL: URL)

        documentToOpen.openWithCompletionHandler() { (success) in
            if success == true {
                self.performSegueWithIdentifier("showDetail", sender: documentToOpen)
            }
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
