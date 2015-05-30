//
//  SOTask.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOTask: NSObject {

    var _title: String = ""
    var _category: String = ""
    var _ico1: String = ""
    var _ico2: String = ""
    var _ico3: String = ""
    var _ico4: String = ""
    var _ico5: String = ""
    var _ico6: String = ""

    override init() {

        super.init()
    }
    
    convenience init(task: Task ) {
        self.init()
        
        self._title = task.title
        self._category = task.category
        self._ico1 = task.ico1
        self._ico2 = task.ico2
        self._ico3 = task.ico3
        self._ico4 = task.ico4
        self._ico5 = task.ico5
        self._ico6 = task.ico6
    }

    var title: String{
        get{
            return _title
        }
    }
    
    var category: String{
        get{
            return SOLocalDataBase.sharedInstance.categoryName(self._category)
        }
    }

    func ico(number : Int) -> UIImage?{
        switch number{
            case 0...5:

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
}
