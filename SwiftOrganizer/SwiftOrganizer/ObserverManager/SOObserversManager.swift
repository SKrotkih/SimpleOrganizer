//
//  SOObserverManager.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//
//  Observer with piorities

import Foundation;

protocol SOObserverProtocol: class{
    func notify(notification: SOObserverNotification)
}

enum SOObserverNotificationTypes: String{
    case SODataBaseTypeChanged = "DataBaseTypeChanged"
    case SODataBaseDidChanged = "DataBaseCloudDidChanged"
}

class SOObserverNotification {
    let type: SOObserverNotificationTypes
    let data: Any?
    
    init(type: SOObserverNotificationTypes, data:Any?) {
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

class SOObserversManager {
    private var _dataBaseTypeChangeObservers = [Dictionary<String, AnyObject>]();
    private var _dataBaseDidChangeObservers = [Dictionary<String, AnyObject>]();
    private var collectionQueue = dispatch_queue_create("colQ", DISPATCH_QUEUE_CONCURRENT);
    
    class var sharedInstance: SOObserversManager {
        struct SingletonWrapper {
            static let sharedInstance = SOObserversManager()
        }

        return SingletonWrapper.sharedInstance;
    }
    
    private init() {
    }
    
    func addObserver(observer: SOObserverProtocol, type: SOObserverNotificationTypes, priority: Int = 0){
        dispatch_barrier_sync(self.collectionQueue, { () in
            let dict: Dictionary<String, AnyObject> = ["priority": priority, "object": WeakObserverReference(observer: observer)]
            
            switch type{
            case .SODataBaseTypeChanged:
                self._dataBaseTypeChangeObservers.append(dict);
                
                // Sort array
                self._dataBaseTypeChangeObservers.sort({
                    let dict0: Dictionary<String, AnyObject> = $0
                    let dict1: Dictionary<String, AnyObject> = $1
                    let priority0 = dict0["priority"] as! Int
                    let priority1 = dict1["priority"] as! Int
                    
                    return priority0 > priority1
                })
            case .SODataBaseDidChanged:
                self._dataBaseDidChangeObservers.append(dict);
                
                // Sort array
                self._dataBaseDidChangeObservers.sort({
                    let dict0: Dictionary<String, AnyObject> = $0
                    let dict1: Dictionary<String, AnyObject> = $1
                    let priority0 = dict0["priority"] as! Int
                    let priority1 = dict1["priority"] as! Int
                    
                    return priority0 > priority1
                })
            default:
                assert(false, "Something is wrong with observer code notification!")
            }
        });
    }

    func removeObserver(observer: SOObserverProtocol, type: SOObserverNotificationTypes){
        dispatch_barrier_sync(self.collectionQueue, { () in
            switch type{
            case .SODataBaseTypeChanged:
                self._dataBaseTypeChangeObservers = filter(self._dataBaseTypeChangeObservers, { dict in
                    let weakref: WeakObserverReference = dict["object"] as! WeakObserverReference
                    return weakref.observer != nil && weakref.observer !== observer;
                })
            case .SODataBaseDidChanged:
                self._dataBaseDidChangeObservers = filter(self._dataBaseDidChangeObservers, { dict in
                    let weakref: WeakObserverReference = dict["object"] as! WeakObserverReference
                    return weakref.observer != nil && weakref.observer !== observer;
                })
            default:
                assert(false, "Something is wrong with observer code notification!")
            }
        })
    }
    
    func sendNotification(notification: SOObserverNotification) {
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
        let weakref: WeakObserverReference = dict["object"] as! WeakObserverReference
        let priority: Int = dict["priority"] as! Int
        
        dispatch_async(dispatch_get_main_queue(), {
            weakref.observer?.notify(notification);
        })
    }
    
}

