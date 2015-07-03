//
//  SOEnterDateViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import EventKit

class SOEnterDateViewController: SOEnterBaseViewController {

    private var _date: NSDate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    convenience init(date: NSDate){
        self.init()
        
        self._date = date
    }
    
    var date: NSDate?{
        get{
            return self._date
        }
        set{
            self._date = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let rightButtonImage : UIImage! = UIImage(named: "save_task")
        var rightButton: UIBarButtonItem = UIBarButtonItem(image: rightButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonWasPressed")
        navigationItem.rightBarButtonItem = rightButton;
        
        if let currTaskDate = self.date{
            self.datePicker.date = currTaskDate
        }
    }

    func doneButtonWasPressed() {
        self.date = self.datePicker.date
        self.closeButtonWasPressed()
    }
    
    @IBAction func todayEnterOnButtonPressed(sender: AnyObject) {
        self.datePicker.date = NSDate()
    }
    
    @IBAction func saveToCalendarOnButtonPressed(sender: AnyObject) {
        var store = EKEventStore()
        
        store.requestAccessToEntityType(EKEntityTypeEvent) { (success: Bool, error: NSError!) in
            if success{
                println("Got permission = \(success)")
                //                    var reminderCalendars =
                //                    store.calendarsForEntityType(EKEntityTypeReminder) as! [EKCalendar]
                
                var eventCalendars = store.calendarsForEntityType(EKEntityTypeEvent) as! [EKCalendar]
                
                if eventCalendars.count > 0 {
                    var theEvent = EKEvent(eventStore: store)
                    
                    for i in 0..<eventCalendars.count{
                        let calendar: EKCalendar! = eventCalendars[i]
                        println("Calendar \(i):"+calendar.title)
                    }
                    
                    theEvent.calendar = eventCalendars[0]
                    theEvent.startDate = self.datePicker.date
                    theEvent.endDate = self.datePicker.date
                    theEvent.title = self.task?.title
                    var error : NSError? = nil
                    store.saveEvent(theEvent, span: EKSpanThisEvent, commit: true, error: &error)
                    
                    if error == nil{
                        println("Event was saved to the Calendar successfully!")
                    } else {
                        println("Event was saved to the Calendar with Error = \(error)")
                    }
                }
            } else {
                println("Got error = \(error)")
            }
        }
    }
    
    override func closeButtonWasPressed() {
        if self.date == self.datePicker.date{
            self.saveData()
            super.closeButtonWasPressed()
        } else {
            self.date = self.datePicker.date
            let controller = UIAlertController(title: "Date was chenged!", message: nil, preferredStyle: .ActionSheet)
            let skeepDateAction = UIAlertAction(title: "Close", style: .Cancel, handler: { action in
                super.closeButtonWasPressed()
            })
            let saveDateAction = UIAlertAction(title: "Save", style: .Default, handler: { action in
                self.saveData()
                super.closeButtonWasPressed()
            })
            controller.addAction(skeepDateAction)
            controller.addAction(saveDateAction)
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

    private func saveData(){
        if let editTask = self.task{
            editTask.date = self.date
        } else {
            let msg = "Warning"
            let controller = UIAlertController(title: "Something is going wrong!", message: msg, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            controller.addAction(cancelAction)
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
}
