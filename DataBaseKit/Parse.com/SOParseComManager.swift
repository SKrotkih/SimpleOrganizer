//
//  SOParseComManager.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/15/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//
// Parse.com 
// Application Calls Handler

import UIKit
import Bolts
import ParseFacebookUtilsV4
import ParseTwitterUtils
import Parse
import ParseUI

public class SOParseComManager: NSObject {
    
    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------
    
     public class func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Enable storing and querying data from Local Datastore.
        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
        Parse.enableLocalDatastore()
        
        // ****************************************************************************
        // Uncomment this line if you want to enable Crash Reporting
        // ParseCrashReporting.enable()
        //
        
        Parse.setApplicationId(ParseDataKeys.ApplicationId, clientKey: ParseDataKeys.ClientKey)
        
        //
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside ParseStartProject-Bridging-Header and the following line here:
        // PFFacebookUtils.initializeFacebook()
        // ****************************************************************************
        
        //PFUser.enableAutomaticUser()
        
        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        //defaultACL.setPublicReadAccess(true)
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)
        
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }

        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }

        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        PFTwitterUtils.initializeWithConsumerKey(TwitterDataKeys.ConsumerKey, consumerSecret: TwitterDataKeys.ConsumerSecret)
        
        return true
    }
}

//--------------------------------------
// MARK: Push Notifications
//--------------------------------------

extension SOParseComManager{
    
    public class func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
        
        PFPush.subscribeToChannelInBackground("", block: { (succeeded: Bool, error: NSError?) -> Void in
            if succeeded {
                print("SwiftOrganizer successfully subscribed to push notifications on the broadcast channel.");
            } else {
                print("SwiftOrganizer failed to subscribe to push notifications on the broadcast channel with error = \(error?.description).")
            }
        })
    }
    
    public class func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    public class func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }
    
    public class func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
        fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
            if application.applicationState == UIApplicationState.Active {
            } else if application.applicationState == UIApplicationState.Inactive {
                PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
            } else if application.applicationState == UIApplicationState.Background {
            }
    }
}

//--------------------------------------
// MARK: Facebook SDK Integration
//--------------------------------------

extension SOParseComManager{
    
    public class func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        ///////////////////////////////////////////////////////////
        // Uncomment this method if you are using Facebook
        ///////////////////////////////////////////////////////////
        // return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication, session:PFFacebookUtils.session())
        return true
    }
}

//--------------------------------------
// MARK: Log In
//--------------------------------------

extension SOParseComManager{
    class func currentUserHasLoggedIn() -> Bool{
        let currentUser = PFUser.currentUser()
        return currentUser != nil
    }
    
    class func userInfo() -> Dictionary<String, String>? {
        if let currentUser = PFUser.currentUser(){
            if let userName: String = currentUser.username{
                let dict: Dictionary<String, String> = ["name": userName, "photo": ""]
                return dict
            }
        }
        
        return nil;
    }
    
    class func logIn(viewController: UIViewController, completionBlock: (error: NSError?) -> Void){
        
        let logInDelegate = PFLogInDelegate.sharedInstance
        
        logInDelegate.completionBlock = completionBlock
        logInDelegate.viewController = viewController
        
        let logInViewController = PFLogInViewController()
        logInViewController.delegate = logInDelegate
        logInViewController.fields = [.UsernameAndPassword, .PasswordForgotten, .LogInButton, .Facebook, .Twitter, .SignUpButton, .DismissButton]
        if let signUpViewController = logInViewController.signUpController {
            signUpViewController.delegate = logInDelegate
            signUpViewController.fields = [.UsernameAndPassword, .Email, .Additional, .SignUpButton, .DismissButton]
        }
        viewController.navigationController?.pushViewController(logInViewController, animated: true)
    }
    
    class func logOut(completionBlock: (error: NSError?) -> Void){
        PFUser.logOut()
        completionBlock(error: nil)
    }
}

    // - MARK: PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate

public final class PFLogInDelegate: NSObject, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    var completionBlock: (error: NSError?) -> Void = {(arg) in}
    var viewController: UIViewController!
    
    public class var sharedInstance: PFLogInDelegate {
        struct SingletonWrapper {
            static let sharedInstance = PFLogInDelegate()
        }
        return SingletonWrapper.sharedInstance;
    }
    
    public func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser){
        self.viewController.navigationController?.popViewControllerAnimated(true)
    }
    
    public func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?){
        self.completionBlock(error: error)
    }
    
}
