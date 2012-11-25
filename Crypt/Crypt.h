//
//  Crypt.h
//  Crypt
//
//  Created by UlhasM on 25/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define CRYPT_ENTITY_NAME @"Crypt"

@interface Crypt : NSManagedObject

@property (nonatomic, retain) NSData * encryptedData;
@property (nonatomic, retain) NSData * initializationVector;
@property (nonatomic, retain) NSData * salt;

@end
