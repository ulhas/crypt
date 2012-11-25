//
//  CryptManager.h
//  Crypt
//
//  Created by UlhasM on 25/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CryptManager : NSObject

+ (NSData *)encryptedDataForString:(NSString *)plainText
              initializationVector:(NSData **)iv
                              salt:(NSData **)salt
                          andError:(NSError **)error;


@end
