//
//  CryptManager.m
//  Crypt
//
//  Created by UlhasM on 25/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CryptManager.h"

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

static NSString * const password = @"IQO!}^ojx$TdID(n";

static NSString * const kCryptManagerErrorDomain = @"com.test.crypt";

const CCAlgorithm kAlgorithm = kCCAlgorithmAES128;
const NSUInteger kAlgorithmKeySize = kCCKeySizeAES128;
const NSUInteger kAlgorithmBlockSize = kCCBlockSizeAES128;
const NSUInteger kAlgorithmIVSize = kCCBlockSizeAES128;
const NSUInteger kPBKDFSaltSize = 8;
const NSUInteger kPBKDFRounds = 10000;

@implementation CryptManager

// ===================

+ (NSData *)randomDataOfLength:(size_t)length {
    NSMutableData *data = [NSMutableData dataWithLength:length];
    
    int result = SecRandomCopyBytes(kSecRandomDefault,
                                    length,
                                    data.mutableBytes);
    NSAssert(result == 0, @"Unable to generate random bytes: %d",
             errno);
    
    return data;
}

// ===================

// Replace this with a 10,000 hash calls if you don't have CCKeyDerivationPBKDF
+ (NSData *)AESKeyForPassword:(NSString *)password
                         salt:(NSData *)salt {
    NSMutableData *
    derivedKey = [NSMutableData dataWithLength:kAlgorithmKeySize];
    
    int
    result = CCKeyDerivationPBKDF(kCCPBKDF2,            // algorithm
                                  password.UTF8String,  // password
                                  password.length,  // passwordLength
                                  salt.bytes,           // salt
                                  salt.length,          // saltLen
                                  kCCPRFHmacAlgSHA1,    // PRF
                                  kPBKDFRounds,         // rounds
                                  derivedKey.mutableBytes, // derivedKey
                                  derivedKey.length); // derivedKeyLen
    
    // Do not log password here
    NSAssert(result == kCCSuccess,
             @"Unable to create AES key for password: %d", result);
    
    return derivedKey;
}

+ (NSData *)encryptedDataForData:(NSData *)data
                 initializationVector:(NSData *__autoreleasing *)iv
                                 salt:(NSData *__autoreleasing *)salt
                             andError:(NSError *__autoreleasing *)error
{
    NSAssert(iv, @"IV must not be NULL");
    NSAssert(salt, @"salt must not be NULL");
    
    *iv = [self randomDataOfLength:kAlgorithmIVSize];
    *salt = [self randomDataOfLength:kPBKDFSaltSize];
    
    NSData *key = [self AESKeyForPassword:password salt:*salt];
    
    size_t outLength;
    NSMutableData *
    cipherData = [NSMutableData dataWithLength:data.length +
                  kAlgorithmBlockSize];
    
    CCCryptorStatus
    result = CCCrypt(kCCEncrypt, // operation
                     kAlgorithm, // Algorithm
                     kCCOptionPKCS7Padding, // options
                     key.bytes, // key
                     key.length, // keylength
                     (*iv).bytes,// iv
                     data.bytes, // dataIn
                     data.length, // dataInLength,
                     cipherData.mutableBytes, // dataOut
                     cipherData.length, // dataOutAvailable
                     &outLength); // dataOutMoved
    
    if (result == kCCSuccess) {
        cipherData.length = outLength;
    }
    else {
        if (error) {
            *error = [NSError errorWithDomain:kCryptManagerErrorDomain
                                         code:result
                                     userInfo:nil];
        }
        return nil;
    }
    
    return cipherData;
}

+ (NSData *)decryptedDataForData:(NSData *)data
            initializationVector:(NSData *)iv
                            salt:(NSData *)salt
                        andError:(NSError *__autoreleasing *)error {
    
    NSData *key = [self AESKeyForPassword:password salt:salt];
    
    size_t outLength;
    NSMutableData *
    decryptedData = [NSMutableData dataWithLength:data.length];
    CCCryptorStatus
    result = CCCrypt(kCCDecrypt, // operation
                     kAlgorithm, // Algorithm
                     kCCOptionPKCS7Padding, // options
                     key.bytes, // key
                     key.length, // keylength
                     iv.bytes,// iv
                     data.bytes, // dataIn
                     data.length, // dataInLength,
                     decryptedData.mutableBytes, // dataOut
                     decryptedData.length, // dataOutAvailable
                     &outLength); // dataOutMoved
    
    if (result == kCCSuccess) {
        [decryptedData setLength:outLength];
    }
    else {
        if (result != kCCSuccess) {
            if (error) {
                *error = [NSError
                          errorWithDomain:kCryptManagerErrorDomain
                          code:result
                          userInfo:nil];
            }
            return nil;
        }
    }
    
    return decryptedData;
}

@end
