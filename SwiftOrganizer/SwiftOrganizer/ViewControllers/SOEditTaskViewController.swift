//
//  SOEditTaskViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOEditTaskViewController: UIViewController {
    
    var task: SOTask?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let editTask = task{
            self.prepareForEditTask(editTask)
        }
        else
        {
            self.prepareForNewTask()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let leftButtonImage: UIImage! = UIImage(named: "back_button")
        var leftButton: UIBarButtonItem = UIBarButtonItem(image: leftButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: "closeButtonWasPressed")
        navigationItem.leftBarButtonItem = leftButton;
        
        let rightButtonImage : UIImage! = UIImage(named: "save_task")
        var rightButton: UIBarButtonItem = UIBarButtonItem(image: rightButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonWasPressed")
        navigationItem.rightBarButtonItem = rightButton;
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    func doneButtonWasPressed() {
        self.saveTask()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func closeButtonWasPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func prepareForEditTask(editTask: SOTask!){
        
        let title  = editTask.title
        let message = "You selected \(title)"
        println(message)
        
    }
    
    func prepareForNewTask(){
        
        println("Add new task!")
        
    }

    func saveTask(){
        
    }
    
    
}