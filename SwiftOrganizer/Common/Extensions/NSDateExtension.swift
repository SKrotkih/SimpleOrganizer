//
//  NSDateExtension.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import Foundation

extension NSDate {

    convenience init(dateString: String, format: String="yyyy-MM-dd"){
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.defaultTimeZone()
        formatter.dateFormat = format
        let d = formatter.dateFromString(dateString)
        self.init(timeInterval: 0, sinceDate: d!)
    }
}

func >(l: NSDate, r: NSDate) -> Bool{
    return l.compare(r) == NSComparisonResult.OrderedDescending
}

func >=(l: NSDate, r: NSDate) -> Bool{
    return l.compare(r) == NSComparisonResult.OrderedDescending || l == r
}

func <(l: NSDate, r: NSDate) -> Bool{
    return l.compare(r) == NSComparisonResult.OrderedAscending
}

func <=(l: NSDate, r: NSDate) -> Bool{
    return l.compare(r) == NSComparisonResult.OrderedAscending || l == r
}
