//
//  EditTaskDateViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/2/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import EventKit

class EditTaskDateViewController: EditTaskDetailViewController {
    private var _date: NSDate?
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var needRememberSwitch: UISwitch!
    @IBOutlet weak var needRememberLabel: UILabel!
    @IBOutlet weak var caveEventToCalendarButton: UIButton!
    
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
        
        self.title = "Date".localized
        self.needRememberLabel.text = "Does need reminder?".localized
        self.caveEventToCalendarButton.setTitle("Save event to the Calendar".localized, forState: .Normal)
        self.needRememberSwitch.on = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let rightButtonImage : UIImage! = UIImage(named: "save_task")
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: rightButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditTaskDateViewController.doneButtonWasPressed))
        navigationItem.rightBarButtonItem = rightButton;
        
        if let currTaskDate = self.date{
            self.datePicker.date = currTaskDate
        }
    }

    override func willFinishEditing() -> Bool{
        return true && super.willFinishEditing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }

    func doneButtonWasPressed() {
        self.date = self.datePicker.date
        self.closeButtonWasPressed()
    }
    
    
    @IBAction func needToRememberChangeState(sender: AnyObject) {
    }
    
    @IBAction func todayEnterOnButtonPressed(sender: AnyObject) {
        self.datePicker.date = NSDate()
    }
    
    @IBAction func saveToCalendarOnButtonPressed(sender: AnyObject) {
        let store = EKEventStore()
        store.requestAccessToEntityType(EKEntityType.Event, completion: {success, error in
            if success{
                print("Got permission = \(success)")
                //                    var reminderCalendars =
                //                    store.calendarsForEntityType(EKEntityTypeReminder) as! [EKCalendar]
                
                var eventCalendars = store.calendarsForEntityType(EKEntityType.Event)
                
                if eventCalendars.count > 0 {
                    let theEvent = EKEvent(eventStore: store)
                    
                    for i in 0..<eventCalendars.count{
                        let calendar: EKCalendar! = eventCalendars[i]
                        print("Calendar \(i):"+calendar.title)
                    }
                    
                    theEvent.calendar = eventCalendars[0]
                    theEvent.startDate = self.datePicker.date
                    theEvent.endDate = self.datePicker.date
                    theEvent.title = (self.delegate?.input.task!.title)!
                    var error : NSError? = nil
                    do {
                        try store.saveEvent(theEvent, span: .ThisEvent, commit: true)
                    } catch let error1 as NSError {
                        error = error1
                    } catch {
                        fatalError()
                    }
                    
                    if let theError = error{
                        print("Event was saved to the Calendar with Error = \(theError)")
                    } else {
                        print("Event was saved to the Calendar successfully!")
                    }
                }
            } else {
                print("Got error = \(error)")
            }
        })
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
        if let theTask = self.delegate?.input.task{
            var dateString: String!
            
            if let oldDate = theTask.date{
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                dateString = dateFormatter.stringFromDate(oldDate)
            } else {
                dateString = ""
            }
            let dict = NSDictionary(objects: [dateString], forKeys: ["date"])
            self.undoDelegate?.addToUndoBuffer(dict)

            
            theTask.date = self.date
        } else {
            let msg = "Warning"
            let controller = UIAlertController(title: "Something is going wrong!", message: msg, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            controller.addAction(cancelAction)
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
}
