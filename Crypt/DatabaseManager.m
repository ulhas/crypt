//
//  DatabaseManager.m
//  Crypt
//
//  Created by UlhasM on 24/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatabaseManager.h"

static DatabaseManager *_sharedManager = nil;

@implementation DatabaseManager

- (DatabaseManager *)sharedManager
{
    if (!_sharedManager) {
        _sharedManager = [[DatabaseManager alloc] init];
    }
    
    return _sharedManager;
}

@end
