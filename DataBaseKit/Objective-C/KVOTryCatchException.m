//
//  KVOTryCatchException.m
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 9/1/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

#import "KVOTryCatchException.h"

@implementation KVOTryCatchException

- (NSError*) trySetKeyValueForObject: (NSManagedObject*) aManagedObject
                          forKeyPath: (NSString*) aKeyPath
                               value: (id) aValue
{
    NSError* error;
    
    @try {
        [aManagedObject setValue: aValue
                          forKey: aKeyPath];
    }
    @catch (NSException* exception) {
        NSDictionary* userInfo = @{NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat: @"%@", exception.reason]};
        error = [NSError errorWithDomain: @"ObjectiveCOrganizerErrorDomain"
                                    code: -1
                                userInfo: userInfo];
    }
    
    return error;
}

@end
