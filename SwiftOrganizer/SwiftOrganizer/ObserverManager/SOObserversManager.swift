//
//  SOObserverManager.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/28/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import Foundation;

protocol SOObserverProtocol: class{
    func notify(notification: SOObserverNotification)
}

enum SOObserverNotificationTypes: String{
    case SODataBaseTypeChanged = "DataBaseTypeChanged"
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
    private var _dataBaseTypeChangeObservers = [WeakObserverReference]();
    private var collectionQueue = dispatch_queue_create("colQ", DISPATCH_QUEUE_CONCURRENT);
    
    class var sharedInstance: SOObserversManager {
        struct SingletonWrapper {
            static let sharedInstance = SOObserversManager()
        }

        return SingletonWrapper.sharedInstance;
    }
    
    private init() {
    }
    
    func addObserver(observer: SOObserverProtocol, type: SOObserverNotificationTypes){
        switch type{
        case .SODataBaseTypeChanged:
            dispatch_barrier_sync(self.collectionQueue, { () in
                self._dataBaseTypeChangeObservers.append(WeakObserverReference(observer: observer));
            });
        default:
            assert(false, "That observer type is absent!")
        }
    }

    func removeObserver(observer: SOObserverProtocol, type: SOObserverNotificationTypes){
        switch type{
        case .SODataBaseTypeChanged:
            dispatch_barrier_sync(self.collectionQueue, { () in
                self._dataBaseTypeChangeObservers = filter(self._dataBaseTypeChangeObservers, { weakref in
                    return weakref.observer != nil && weakref.observer !== observer;
                });
            });
        default:
            assert(false, "That observer type is absent!")
        }
    }
    
    func sendNotification(notification: SOObserverNotification) {
        switch notification.type{
        case .SODataBaseTypeChanged:
            dispatch_sync(self.collectionQueue, { () in
                for ob in self._dataBaseTypeChangeObservers {
                    ob.observer?.notify(notification);
                }
            });
        default:
            assert(false, "That observer type is absent!")
        }
    }
}

