//
//  StringExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/22/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import Foundation

extension String {
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
    
    func toIndexPath () -> NSIndexPath{
        let components = self.componentsSeparatedByString("-")
        
        if components.count == 2{
            let section = components[0]
            let row = components[1]
            
            if let theSection = section.toInt(){
                
                if let theRow = row.toInt(){
                    return NSIndexPath(forRow: theRow, inSection: theSection)
                }
            }
        }
        return NSIndexPath()
    }
}
