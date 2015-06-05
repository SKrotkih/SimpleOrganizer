//
//  SOTask.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

let MaxIconsCount = 6

class SOTask: NSObject {

    var _taskObject: Task?
    var _title: String = ""
    var _category: String = ""
    var _ico1: String = ""
    var _ico2: String = ""
    var _ico3: String = ""
    var _ico4: String = ""
    var _ico5: String = ""
    var _ico6: String = ""
    var _date: NSDate?

    override init() {
        super.init()
        
    }
    
    convenience init(task: Task ) {
        self.init()
        
        self._taskObject = task
        self._title = task.title
        self._category = task.category
        self._ico1 = task.ico1
        self._ico2 = task.ico2
        self._ico3 = task.ico3
        self._ico4 = task.ico4
        self._ico5 = task.ico5
        self._ico6 = task.ico6
        self._date = task.date
    }

    var maxIconsCount: Int{
        get{
            return MaxIconsCount;
        }
    }
   
    var title: String{
        get{
            return _title
        }
        set{
            self._title = newValue
        }
    }
    
    var category: String{
        get{
            return SOLocalDataBase.sharedInstance.categoryName(self._category)
        }
        set{
            self._category = newValue
        }
    }

    var date: NSDate{
        get{
            if let currDate = _date{
                return currDate
            }
            
            return NSDate()
        }
        set{
            _date = newValue
        }
    }
    
    func ico(number : Int) -> UIImage?{
        switch number{
            case 0..<MaxIconsCount:

                let icoIds : [String] = [_ico1, _ico2, _ico3, _ico4, _ico5, _ico6]
                
                let imageName : String = SOLocalDataBase.sharedInstance.iconsImageName(icoIds[number])
                
                if imageName == "" {
                    return nil
                }
                
                let image : UIImage = UIImage(named: imageName)!
                
                return image
            
        default:
            
            return nil
        }
    }
    
    func dateString() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        if let date = _date{
            return dateFormatter.stringFromDate(date)
        }
        
        return ""
    }
    
    func save() -> Void{
        
        if let object = _taskObject{
            self.copyTaskToObject(object)
        }
        else{
            let object = SOLocalDataBase.sharedInstance.newTaskManagedObject()
            self.copyTaskToObject(object)
        }
        
       SOLocalDataBase.sharedInstance.saveContext()
        
    }
    
    func remove(){
        SOLocalDataBase.sharedInstance.deleteObject(_taskObject)
    }
    
    func copyTaskToObject(object: Task!){
        object.title = self._title
        object.category = self._category
        object.ico1 = self._ico1
        object.ico2 = self._ico2
        object.ico3 = self._ico3
        object.ico4 = self._ico4
        object.ico5 = self._ico5
        object.ico6 = self._ico6
        if let date = self._date{
            object.date = date
        }
    }
    
}
