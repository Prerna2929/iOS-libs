//
//  PLKString.m
//  App
//
//  Created by Alvaro Talavera on 5/26/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKString.h"

@implementation PLKString

+ (BOOL)isNSStringEmpty:(NSString *)string
{
    if(string != nil && ![string isKindOfClass:[NSNull class]] && ![string isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

+ (NSString *)removeLatinCharacters:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+ (NSString *)urlEncode:(NSString *)str
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)str,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
}

@end
