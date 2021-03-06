//
//  SOiCloudManager.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 7/4/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import Foundation

public final class SOiCloudManager {
    
    class var sharedInstance: SOiCloudManager {
        struct SingletonWrapper {
            static let sharedInstance = SOiCloudManager()
        }
        return SingletonWrapper.sharedInstance;
    }

    private init() {
        SOObserversManager.sharedInstance.addObserver(self, type: .SODataBaseTypeChanged)
    }
    
    deinit{
        SOObserversManager.sharedInstance.removeObserver(self, type: .SODataBaseTypeChanged)
    }
    
    func updateKeyValueStoreKey(key: String, object: AnyObject){
        let kvStore: NSUbiquitousKeyValueStore = NSUbiquitousKeyValueStore.defaultStore();
        kvStore.setObject(object, forKey: key)
    }

    func syncKeyValueStore() {
        let kvStore: NSUbiquitousKeyValueStore = NSUbiquitousKeyValueStore.defaultStore();
        kvStore.synchronize()
    }
    
    func prepareKeyValueStoreObserver(){
        let kvStore: NSUbiquitousKeyValueStore = NSUbiquitousKeyValueStore.defaultStore();
        let notificationsCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        notificationsCenter.addObserver(self, selector: #selector(SOiCloudManager.keyValueStoreDidChange(_:)), name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: kvStore)
        
        syncKeyValueStore()
    }
    
    func cleanKeyValueStoreObserver(){
        let notificationsCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        notificationsCenter.removeObserver(self)
    }
    
    @objc func keyValueStoreDidChange(notifcations: NSNotification){
        let userInfo: Dictionary = notifcations.userInfo!

        if let reasongForChange: AnyObject? = userInfo[NSUbiquitousKeyValueStoreChangeReasonKey]{
            let reason: Int = reasongForChange as! Int

            if reason == NSUbiquitousKeyValueStoreServerChange || reason == NSUbiquitousKeyValueStoreInitialSyncChange{
                let changedKeysObject: AnyObject? = userInfo[NSUbiquitousKeyValueStoreChangedKeysKey]
                
                if let changedKeys: Array<String> = changedKeysObject as? Array<String>{
                    let kvStore: NSUbiquitousKeyValueStore = NSUbiquitousKeyValueStore.defaultStore();
                    let userDefaults: NSUserDefaults = DefaultsUser.sharedDefaults()
                    
                    for key: String in changedKeys{
                        let valueObject: AnyObject? = kvStore.objectForKey(key)
                        
                        if let value: AnyObject = valueObject{
                            userDefaults.setObject(value, forKey: key)
                            userDefaults.synchronize()

                            let expectedKey: String = SOObserverNotificationTypes.SODataBaseTypeChanged.rawValue

                            if key == expectedKey{

                                if let currDataBaseName = userDefaults.stringForKey(DefaultsDataKeys.SODataBaseTypeKey){
                                
                                    if currDataBaseName == value as! String{
                                        continue
                                    }
                                }
                                userDefaults.setObject(value, forKey: DefaultsDataKeys.SODataBaseTypeKey)

                                if  userDefaults.synchronize(){
                                    let notification: SOObserverNotification = SOObserverNotification(type: .SODataBaseTypeChanged, data: nil)
                                    SOObserversManager.sharedInstance.sendNotification(notification)
                                    SOLocalNotificationsCenter.sendLocalNotification("Type of DataBase was changed to \(value)!".localized, timeIntervalSinceNow: 1)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension SOiCloudManager: SOObserverProtocol {
    public func notify(notification: SOObserverNotification){
        switch notification.type{
        case .SODataBaseTypeChanged:
            if let value: String = notification.data as? String{
                let key: String = SOObserverNotificationTypes.SODataBaseTypeChanged.rawValue
                self.updateKeyValueStoreKey(key, object: value)
            }
            
        default:
            assert(false, "Something is wrong with observer code notification!")
        }
    }
}
