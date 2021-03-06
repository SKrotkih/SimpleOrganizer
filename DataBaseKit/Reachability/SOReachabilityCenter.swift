//
//  SOReachability.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 8/8/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import Foundation

typealias SOReachabilityObserverType = () -> Void

@objc

public class SOReachabilityCenter: NSObject{

    var changeReachableBlock: SOReachabilityObserverType!
    let reachability = Reachability.reachabilityForInternetConnection()
    
    public class var sharedInstance: SOReachabilityCenter {
        struct SingletonWrapper {
            static let sharedInstance = SOReachabilityCenter()
        }
        
        return SingletonWrapper.sharedInstance;
    }
    
    deinit{
        self.reachability!.stopNotifier()
    }
    
    public func isInternetConnected() -> Bool{
        return self.reachability!.isReachable()
    }

    func startInternetObserver(completionBlock: () -> Void  ){
        self.changeReachableBlock = completionBlock
        
        self.reachability!.whenReachable = { reachability in
            self.changeReachableBlock()
        }

        self.reachability!.whenUnreachable = { reachability in
            self.changeReachableBlock()
        }
        
        self.reachability!.startNotifier()
    }
    
    func stopInternetObserver(){
        reachability!.stopNotifier()
    }
    
}
