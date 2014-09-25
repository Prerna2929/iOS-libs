//
//  PLKCache.m
//  LlevaUno
//
//  Created by Ignacio Rojas on 4/28/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKCache.h"

@implementation PLKCache

+ (NSMutableDictionary *)sharedCache
{
    static NSMutableDictionary *cache = nil;
    static dispatch_once_t onceTokenCache;
    dispatch_once(&onceTokenCache, ^{ cache = [[NSMutableDictionary alloc] init]; });
    return cache;
}

@end
