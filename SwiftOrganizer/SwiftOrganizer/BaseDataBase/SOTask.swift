//
//  SOTask.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

let MaxIconsCount = 6

class SOTask: NSObject{

    private var _databaseObject: AnyObject?
    private var _title: String = ""
    private var _category: String = ""
    private var _icons = [String](count: MaxIconsCount, repeatedValue: "")
    private var _date: NSDate?

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
            return self._category
        }
        set{
            self._category = newValue
        }
    }

    var icons: [String]{
        get{
            return _icons
        }
        set{
            _icons = newValue
        }
    }
    
    var date: NSDate?{
        get{
            return _date
        }
        set{
            _date = newValue
        }
    }

    var categoryName: String{
        get{
            let categoryId = self._category
            
            if let returnValue = SODataFetching.sharedInstance.categoryName(categoryId){
                return returnValue
            }
            
            return ""
        }
    }
    
    func iconImage(index: Int) -> UIImage?{
        if index < _icons.count{
            let icoId = _icons[index]
            if let imageName : String = SODataFetching.sharedInstance.iconsImageName(icoId){
                if let image : UIImage = UIImage(named: imageName){
                    return image
                }
            }
        }
        
        return nil
    }

    func setIcon(index: Int, newValue: String){
        if index < _icons.count{
            _icons[index] = newValue
        }
    }
    
    var databaseObject: AnyObject?{
        get{
            return _databaseObject
        }
        set{
            _databaseObject = newValue
        }
    }

    func save(block: (error: NSError?) -> Void){
        SODataBaseFactory.sharedInstance.dataBase.saveTask(self, block: {(error: NSError?) in
            block(error: error)
        })
    }
    
    func remove(){
        SODataBaseFactory.sharedInstance.dataBase.removeTask(self)
    }
}
