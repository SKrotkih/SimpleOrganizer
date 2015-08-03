//
//  SOObserverManager.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//
//  Observer with piorities

import Foundation;

let kPriorityKey = "priority"
let kObjectKey = "object"

public protocol SOObserverProtocol: class{
    func notify(notification: SOObserverNotification)
}

public enum SOObserverNotificationTypes: String{
    case SODataBaseTypeChanged = "DataBaseTypeChanged"
    case SODataBaseDidChanged = "DataBaseCloudDidChanged"
}

public class SOObserverNotification {
    public let type: SOObserverNotificationTypes
    public let data: Any?
    
    public init(type: SOObserverNotificationTypes, data:Any?) {
        self.type = type;
        self.data = data;
    }
}

private class WeakObserverReference {
    weak var observer: SOObserverProtocol?;
    
    init(observer: SOObserverProtocol) {
        self.observer = observer;
    }
}

public class SOObserversManager {
    private var _dataBaseTypeChangeObservers = [Dictionary<String, AnyObject>]();
    private var _dataBaseDidChangeObservers = [Dictionary<String, AnyObject>]();
    private var collectionQueue = dispatch_queue_create("colQ", DISPATCH_QUEUE_CONCURRENT);
    
    public class var sharedInstance: SOObserversManager {
        struct SingletonWrapper {
            static let sharedInstance = SOObserversManager()
        }

        return SingletonWrapper.sharedInstance;
    }
    
    private init() {
    }
    
    public func addObserver(observer: SOObserverProtocol, type: SOObserverNotificationTypes, priority: Int = 0){
        dispatch_barrier_sync(self.collectionQueue, { () in
            let dict: Dictionary<String, AnyObject> = [kPriorityKey: priority, kObjectKey: WeakObserverReference(observer: observer)]
            
            switch type{
            case .SODataBaseTypeChanged:
                self._dataBaseTypeChangeObservers.append(dict);
                
                // Sort array
                self._dataBaseTypeChangeObservers.sort({
                    let dict0: Dictionary<String, AnyObject> = $0
                    let dict1: Dictionary<String, AnyObject> = $1
                    let priority0 = dict0[kPriorityKey] as! Int
                    let priority1 = dict1[kPriorityKey] as! Int
                    
                    return priority0 > priority1
                })
            case .SODataBaseDidChanged:
                self._dataBaseDidChangeObservers.append(dict);
                
                // Sort array
                self._dataBaseDidChangeObservers.sort({
                    let dict0: Dictionary<String, AnyObject> = $0
                    let dict1: Dictionary<String, AnyObject> = $1
                    let priority0 = dict0[kPriorityKey] as! Int
                    let priority1 = dict1[kPriorityKey] as! Int
                    
                    return priority0 > priority1
                })
            default:
                assert(false, "Something is wrong with observer code notification!")
            }
        });
    }

    public func removeObserver(observer: SOObserverProtocol, type: SOObserverNotificationTypes){
        dispatch_barrier_sync(self.collectionQueue, { () in
            switch type{
            case .SODataBaseTypeChanged:
                self._dataBaseTypeChangeObservers = filter(self._dataBaseTypeChangeObservers, { dict in
                    let weakref: WeakObserverReference = dict[kObjectKey] as! WeakObserverReference
                    return weakref.observer != nil && weakref.observer !== observer;
                })
            case .SODataBaseDidChanged:
                self._dataBaseDidChangeObservers = filter(self._dataBaseDidChangeObservers, { dict in
                    let weakref: WeakObserverReference = dict[kObjectKey] as! WeakObserverReference
                    return weakref.observer != nil && weakref.observer !== observer;
                })
            default:
                assert(false, "Something is wrong with observer code notification!")
            }
        })
    }
    
    public func sendNotification(notification: SOObserverNotification) {
        dispatch_sync(self.collectionQueue, { () in
            switch notification.type{
            case .SODataBaseTypeChanged:
                for dict in self._dataBaseTypeChangeObservers {
                    self.notifyObserver(dict, notification: notification)
                }
            case .SODataBaseDidChanged:
                for dict in self._dataBaseDidChangeObservers {
                    self.notifyObserver(dict, notification: notification)
                }
            default:
                assert(false, "Something is wrong with observer code notification!")
            }
        });
    }
    
    private func notifyObserver(dict: Dictionary<String, AnyObject>, notification: SOObserverNotification){
        let weakref: WeakObserverReference = dict[kObjectKey] as! WeakObserverReference
        let priority: Int = dict[kPriorityKey] as! Int
        
        dispatch_async(dispatch_get_main_queue(), {
            weakref.observer?.notify(notification);
        })
    }
    
}

