//
//  DatabaseManager.h
//  Crypt
//
//  Created by UlhasM on 24/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseManager : NSObject

- (DatabaseManager *)sharedManager;
@property (nonatomic, assign) NSManagedObjectContext *managedObjectContext;

@end
