//
//  SOSampleDocument.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 7/12/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOSampleDocument: UIDocument {
    var text: String = ""
    
    override func loadFromContents(contents: AnyObject, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
        self.text = ""
        if let data = contents as? NSData {
            if data.length > 0 {
                // Attempt to decode the data into text; if it's successful // store it in self.text
                if let theText = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    self.text = theText as String
                }
            }
        }
        
        return true
    }
    
    // Called when the system needs a snapshot of the current state of // the document, for autosaving.
    override func contentsForType(typeName: String,  error outError: NSErrorPointer) -> AnyObject? {
        return self.text.dataUsingEncoding(NSUTF8StringEncoding)
    }
}
