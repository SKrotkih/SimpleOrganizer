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
