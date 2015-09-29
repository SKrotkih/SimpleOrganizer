//
//  KVOTryCatchException.h
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 9/1/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface KVOTryCatchException : NSObject

- (NSError*) trySetKeyValueForObject: (NSManagedObject*) aManagedObject
                          forKeyPath: (NSString*) aKeyPath
                               value: (id) aValue;

@end
