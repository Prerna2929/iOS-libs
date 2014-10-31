//
//  PLKString.h
//  App
//
//  Created by Alvaro Talavera on 5/26/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLKString : NSObject

+ (BOOL)isNSStringEmpty:(NSString *)string;

+ (NSString *)removeLatinCharacters:(NSString *)string;

+ (NSString *)urlEncode:(NSString *)str;

@end
