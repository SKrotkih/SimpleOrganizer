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
    BOOL _facebookIsLoggedIn;
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

- (void) logInWithFacebookWithViewControoler: (UIViewController*) aViewController
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
             [self facebookUserInfoWithCompletionBlock: ^(NSError* anError, NSDictionary* anUser){
                 
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

                 _facebookIsLoggedIn = YES;
                 
                 NSLog(@"%@", anUser);

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
         
         NSDictionary* user = result;
         aCompletionBlock(nil, user);
     }];
}

#pragma mark - Log Out

- (void) logOutWithSuccessBlock: (void(^)()) aCompletionBlock
{
    SOUser* currentUser = [SOUser currentUser];
    
    if (!currentUser)
    {
        return;
    }
    
    currentUser.isItCurrentUser = NO;
    
    if (_facebookIsLoggedIn)
    {
        FBSDKLoginManager* login = [[FBSDKLoginManager alloc] init];
        [login logOut];
        
        _facebookIsLoggedIn = NO;
    }
    
    aCompletionBlock();
    
}

- (void) logOutAlertWithViewController: (UIViewController*) aViewController
                       completionBlock: (void(^)()) aCompletionBlock
{
    SOUser* currentUser = [SOUser currentUser];
    
    if (currentUser)
    {
        self.completionBlock = aCompletionBlock;
        
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle: nil
                                                           delegate: self
                                                  cancelButtonTitle: NSLocalizedString(@"Cancel", nil)
                                             destructiveButtonTitle: nil
                                                  otherButtonTitles: NSLocalizedString(@"Log Out", nil), nil];
        [sheet showInView: aViewController.view];
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
    if (buttonIndex == 0)
    {
        [self logOutWithSuccessBlock:^{
            self.completionBlock();
        }];
    }
}

@end
