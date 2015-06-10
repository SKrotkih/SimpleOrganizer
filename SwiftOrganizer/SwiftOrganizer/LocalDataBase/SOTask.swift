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

    private var _taskObject: Task?
    private var _title: String
    private var _category: String
    private var _ico1: String
    private var _ico2: String
    private var _ico3: String
    private var _ico4: String
    private var _ico5: String
    private var _ico6: String
    private var _date: NSDate?

    override init() {
        _taskObject = nil
        _title = ""
        _category = ""
        _ico1 = ""
        _ico2 = ""
        _ico3 = ""
        _ico4 = ""
        _ico5 = ""
        _ico6 = ""
        _date = nil
        
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

    func copyToObject(object: Task){
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
            if let returnValue = SOLocalDataBase.sharedInstance.categoryName(self._category){
                return returnValue
            }
            
            return ""
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
    
    func ico(index: Int) -> UIImage?{
        if index < MaxIconsCount{
            let icoIds : [String] = [_ico1, _ico2, _ico3, _ico4, _ico5, _ico6]
            
            if let imageName : String = SOLocalDataBase.sharedInstance.iconsImageName(icoIds[index]){
                if let image : UIImage = UIImage(named: imageName){
                    return image
                }
            }
        }
        
        return nil
    }

    func icoId(index: Int) -> String?{
        let icoIds = [_ico1, _ico2, _ico3, _ico4, _ico5, _ico6]

        if index < icoIds.count{
            let icoId = icoIds[index]
            if icoId != ""{
                return icoId
            }
        }
        
        return nil
    }
    
    func putIco(index: Int, newValue: String){
        if index < MaxIconsCount{
            switch index{
            case 0: _ico1 = newValue
            case 1: _ico2 = newValue
            case 2: _ico3 = newValue
            case 3: _ico4 = newValue
            case 4: _ico5 = newValue
            case 5: _ico6 = newValue
            default: break
            }
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
            self.copyToObject(object)
        }
        else{
            let object = SOLocalDataBase.sharedInstance.newTaskManagedObject()
            self.copyToObject(object)
        }
        
       SOLocalDataBase.sharedInstance.saveContext()
        
    }
    
    func remove(){
        SOLocalDataBase.sharedInstance.deleteObject(_taskObject)
    }
    
}
