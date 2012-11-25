//
//  DatabaseManager.m
//  Crypt
//
//  Created by UlhasM on 24/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatabaseManager.h"
#import "Crypt.h"

static DatabaseManager *_sharedManager = nil;

@implementation DatabaseManager

#pragma mark - Singleton Method

+ (DatabaseManager *)sharedManager
{
    @synchronized ([self class]) {
        if (!_sharedManager)
            _sharedManager = [[DatabaseManager alloc] init];
    }
    
    return _sharedManager;
}

#pragma mark - Crypt Methods

- (void)addCryptToDatabaseWithEncryptedData:(NSData *)encryptedData
                       initializationVector:(NSData *)iv
                                       salt:(NSData *)salt
{
    Crypt *_crypt = [NSEntityDescription insertNewObjectForEntityForName:CRYPT_ENTITY_NAME
                                                  inManagedObjectContext:self.managedObjectContext];
    
    _crypt.encryptedData = encryptedData;
    _crypt.salt = salt;
    _crypt.initializationVector = iv;
}

- (Crypt *)cryptFromDatabase
{
    NSFetchRequest *_cryptRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *_entity = [NSEntityDescription entityForName:CRYPT_ENTITY_NAME
                                               inManagedObjectContext:self.managedObjectContext];
    _cryptRequest.entity = _entity;
    
    NSError *error;
    NSArray *_fetchArray = [self.managedObjectContext executeFetchRequest:_cryptRequest error:&error];
    
    if (error) {
        NSLog(@"Error : %@", error);
        return nil;
    }
    
    if (!_fetchArray)
        return nil;
    
    Crypt *_crypt = nil;
    @try {
        _crypt = [_fetchArray objectAtIndex:0];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception Description : %@", exception.description);
    }
    
    return _crypt;
}

- (void)deleteCryptFromDatabase:(Crypt *)crypt
{
    [self.managedObjectContext deleteObject:crypt];
}

@end
