//
//  AILogInManager.m
//  TheBestPlace
//
//  Created by Sergey Krotkih on 9/5/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

#import "AILogInManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <DataBaseKit/DataBaseKit-Swift.h>
#import "Utils.h"

@interface AILogInManager() <UIAlertViewDelegate, UIActionSheetDelegate>
@property (nonatomic, copy) void(^completionBlock)();
@end

@implementation AILogInManager
{
    UIActionSheet* _logOutSheet;
}

+ (AILogInManager*) sharedInstance
{
    static AILogInManager* instance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[AILogInManager alloc] init];
    });
    
    return instance;
}

- (NSError*) inernalError
{
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject: NSLocalizedString(@"Internal error!", nil)
                                                         forKey: NSLocalizedFailureReasonErrorKey];
    NSError* error = [[NSError alloc] initWithDomain: NSNetServicesErrorDomain
                                                code: -1
                                            userInfo: userInfo];
    return error;
}

#pragma mark - Log In by Facebook

- (BOOL) isCurrentUserAlreadyLoggedIn
{
    return UsersWorker.sharedInstance.currentUser != nil;
}

- (void) logInViaFacebookWithViewControoler: (UIViewController*) aViewController
                             completionBlock: (void(^)(AILoginState aLoginState)) aCompletionBlock
{

    if (![[SOReachabilityCenter sharedInstance] isInternetConnected])
    {
        aCompletionBlock(InternetIsNotPresented);
        
        return;
    }
    FBSDKLoginManager* login = [[FBSDKLoginManager alloc] init];
    
    [login logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
                 fromViewController: aViewController
                            handler: ^(FBSDKLoginManagerLoginResult* result, NSError* error)
     {
         if (error)
         {
             NSString* message = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?: @"There was a problem logging in, please try again later.";
             UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle: message
                                                                delegate: self
                                                       cancelButtonTitle: NSLocalizedString(@"OK", nil)
                                                  destructiveButtonTitle: nil
                                                       otherButtonTitles: nil, nil];
             [sheet showInView: aViewController.view];
             aCompletionBlock(FailedToRunLogIn);
         }
         else if (result.isCancelled)
         {
             aCompletionBlock(LogInCancelled);
         }
         else
         {
             [self facebookUserInfoWithCompletionBlock: ^(NSError* anError, NSDictionary* anUserDict){
                 
                 if (anError)
                 {
                     UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle: [anError localizedDescription]
                                                                        delegate: self
                                                               cancelButtonTitle: NSLocalizedString(@"OK", nil)
                                                          destructiveButtonTitle: nil
                                                               otherButtonTitles: nil, nil];
                     [sheet showInView: aViewController.view];
                     aCompletionBlock(FailedToRunLogIn);
                     
                     return;
                 }
                 [UsersWorker.sharedInstance saveUserData: anUserDict];
                 aCompletionBlock(OperationIsRanSuccessfully);
             }];
         }
     }];
}

- (void) facebookUserInfoWithCompletionBlock: (void(^)(NSError* anError, NSDictionary* anUser)) aCompletionBlock
{
    if (![FBSDKAccessToken currentAccessToken])
    {
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject: NSLocalizedString(@"Internal Facebook connect error!", nil)
                                                             forKey: NSLocalizedFailureReasonErrorKey];
        NSError* error = [[NSError alloc] initWithDomain: NSNetServicesErrorDomain
                                                    code: -1
                                                userInfo: userInfo];
        aCompletionBlock(error, nil);
        
        return;
    }
    NSDictionary* parameters = @{@"fields": @"picture,id,birthday,email,name,gender,first_name,last_name"};
    FBSDKGraphRequest* request = [[FBSDKGraphRequest alloc] initWithGraphPath: @"me"
                                                                   parameters: parameters];
    
    [request startWithCompletionHandler: ^(FBSDKGraphRequestConnection *connection, id result, NSError* error)
     {
         if (error)
         {
             aCompletionBlock(error, nil);
             
             return;
         }
         NSDictionary* dict = result;
         aCompletionBlock(nil, dict);
     }];
}

#pragma mark - Log Out

- (void) logOutWithSuccessBlock: (void(^)()) aCompletionBlock
{
    User* currentUser = UsersWorker.sharedInstance.currentUser;

    if (currentUser == nil)
    {
        return;
    }
    UsersWorker.sharedInstance.currentUser = nil;
    FBSDKLoginManager* loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    aCompletionBlock();
}

- (void) logOutAlertWithViewController: (UIViewController*) aViewController
                       completionBlock: (void(^)()) aCompletionBlock
{
    User* currentUser = UsersWorker.sharedInstance.currentUser;
    
    if (currentUser)
    {
        self.completionBlock = aCompletionBlock;
        
        _logOutSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                           delegate: self
                                                  cancelButtonTitle: NSLocalizedString(@"Cancel", nil)
                                             destructiveButtonTitle: nil
                                                  otherButtonTitles: NSLocalizedString(@"Log Out", nil), nil];
        [_logOutSheet showInView: aViewController.view];
    }
}

- (void) willPresentActionSheet: (UIActionSheet*) actionSheet
{
    [actionSheet.subviews enumerateObjectsUsingBlock: ^(UIView* subview, NSUInteger idx, BOOL* stop)
     {
         if ([subview isKindOfClass: [UIButton class]])
         {
             UIButton* button = (UIButton*) subview;
             button.titleLabel.textColor = [Utils colorWithRGBHex: 0xFA6407];
         }
     }];
}

- (void) actionSheet: (UIActionSheet*) actionSheet didDismissWithButtonIndex: (NSInteger) buttonIndex
{
    if (actionSheet == _logOutSheet && buttonIndex == 0)
    {
        __weak AILogInManager* weakSelf = self;
        
        [self logOutWithSuccessBlock: ^{
            weakSelf.completionBlock();
        }];
    }
}

@end
