//
//  PLKDatabase.m
//
//  Created by Alvaro Talavera on 2/25/14.
//  Copyright (c) 2014 Alvaro Talavera. All rights reserved.
//

#import "PLKSimpleDatabase.h"

@implementation PLKSimpleDatabase

+ (void)set:(NSString *)key value:(NSString *)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
}


+ (NSString *)get:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

@end
