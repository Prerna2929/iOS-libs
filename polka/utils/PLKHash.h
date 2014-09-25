//
//  PLKHash.h
//  LlevaUno
//
//  Created by Ignacio Rojas on 4/28/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface PLKHash : NSObject

+ (NSString *)sha1WithString:(NSString *)input;

+ (NSString *)md5WithString:(NSString *)input;

+ (NSString *)uuid;

@end
