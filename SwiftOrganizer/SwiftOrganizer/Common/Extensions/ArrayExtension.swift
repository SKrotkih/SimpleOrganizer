//
//  ArrayExtension.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import Foundation

extension Array {
    mutating func remove<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.removeAtIndex(index!)
        }
    }
    
    func each(f: (T) -> ()) {
        for object in self {
            f(object)
        }
    }
    
    func remove(functor: (T) -> Bool) -> [T] {
        var tmpArray = [T]()
        for object in self {
            let theObject = object as T
            if functor(theObject) == false {
                tmpArray.append(theObject)
            }
        }
        return tmpArray
    }
}