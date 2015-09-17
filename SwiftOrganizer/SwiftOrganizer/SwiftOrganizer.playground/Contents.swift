//: Playground - noun: a place where people can play

import Foundation
import UIKit

class LogItem {
    var from:String?;
    @NSCopying var data:NSArray?
    var logarray: [Int]?
}

var dataArray = NSMutableArray(array: [1, 2, 3, 4]);
var logitem = LogItem()

logitem.from = "Alice";
logitem.data = dataArray;

dataArray[1] = 10;

print("Value: \(logitem.data![1])");

var locarray = [1,2,3,4]
logitem.logarray = locarray

locarray[1] = 10
print("Value: \(logitem.logarray![1])");



class A {
    private var _name: String?
    
    private(set) var name: String {
        get { return "Hello, \(self._name!)" }
        set { self._name = newValue }
    }
    
    init(_ name:String) {
        self.name = name
    }
    
    func publicname() -> String{
        return self.name
    }
    
}

let a = A("Andrew")
a.name = "Tom"

a.publicname()

