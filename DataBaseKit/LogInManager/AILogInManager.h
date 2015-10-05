//
//  AILogInManager.h
//  TheBestPlace
//
//  Created by Sergey Krotkih on 9/5/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UserIdIsWrong,
    UserNameIsWrong,
    PasswordIsWrong,
    InternetIsNotPresented,
    FailedToRunLogIn,
    OperationIsRanSuccessfully,
    LogInCancelled
} AILoginState;

@interface AILogInManager : NSObject

+ (AILogInManager*) sharedInstance;

- (BOOL) isCurrentUserLoggedInFacebook;

- (void) logInWithFacebookWithViewControoler: (UIViewController*) aViewController
                             completionBlock: (void(^)(AILoginState aLoginState)) aCompletionBlock;

- (void) logOutAlertWithViewController: (UIViewController*) aViewController
                       completionBlock: (void(^)()) aCompletionBlock;

@end
