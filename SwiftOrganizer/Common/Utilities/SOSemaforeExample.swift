//
//  SOSemaforeExample.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 8/1/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import Foundation

protocol HttpHeaderRequest {
    func getHeader(url:String, header:String) -> String?;
}

class HttpHeaderRequestProxy : HttpHeaderRequest {
    
    private let semaphore = dispatch_semaphore_create(0);
    
    func getHeader(url: String, header: String) -> String? {
        var headerValue:String?;
        let nsUrl = NSURL(string: url);
        let request = NSURLRequest(URL: nsUrl!);
        
        NSURLSession.sharedSession().dataTaskWithRequest(request,
            completionHandler: {data, response, error in
                if let httpResponse = response as? NSHTTPURLResponse {
                    headerValue = httpResponse.allHeaderFields[header] as? String;
                }
                dispatch_semaphore_signal(self.semaphore);
        }).resume();
        
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        
        return headerValue;
    }
}


// MARK: - Exception Handler Example

/*

public enum JSONDecodingError: ErrorType {
    case MissingAttribute(String)
}


public init(json: [NSObject: AnyObject]) throws {
    guard let objectId = json["objectId"] as? String else {
        throw JSONDecodingError.MissingAttribute("objectId")
    }
}

do {
    let employee = try Employee(json: dict)
    employees.append(employee)
} catch JSONDecodingError.MissingAttribute(let missingAttribute) {
    print("Unable to load employee, missing attribute: \(missingAttribute)")
} catch {
    fatalError("Something's gone terribly wrong: \(error)")
}
phone
*/
