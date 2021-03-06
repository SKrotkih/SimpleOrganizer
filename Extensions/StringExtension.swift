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
            
            if let theSection = Int(section){
                
                if let theRow = Int(row){
                    return NSIndexPath(forRow: theRow, inSection: theSection)
                }
            }
        }
        return NSIndexPath()
    }
    
    // MARK: Validation e-mail
    
    func isValidEmail() -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
    
    // MARK: Validation Phonen number

    
    func isValidPhoneNumber() -> Bool {
        // println("validate calendar: \(testStr)")
        let phoneNumberRegEx = "^((\\+)|(00))[0-9]{6,14}$"
        
        let phoneNumberTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegEx)
        return phoneNumberTest.evaluateWithObject(self)
    }
    
    
}
