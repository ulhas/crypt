//
//  DatabaseManager.h
//  Crypt
//
//  Created by UlhasM on 24/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Crypt;

@interface DatabaseManager : NSObject

@property (nonatomic, assign) NSManagedObjectContext *managedObjectContext;

+ (DatabaseManager *)sharedManager;

- (void)addCryptToDatabaseWithEncryptedData:(NSData *)encryptedData
                       initializationVector:(NSData *)iv
                                       salt:(NSData *)salt;
- (Crypt *)cryptFromDatabase;
- (void)deleteCryptFromDatabase:(Crypt *)crypt;

@end
