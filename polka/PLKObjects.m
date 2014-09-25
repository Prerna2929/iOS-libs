//
//  PLKObjects.m
//  App
//
//  Created by Alvaro Talavera on 5/30/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKObjects.h"
#import <objc/runtime.h>

@implementation PLKObjects

+ (BOOL)classDescendsFromClass:(Class)classA classB:(Class)classB
{
    while(classA)
    {
        if(classA == classB) return YES;
        classA = class_getSuperclass(classA);
    }
    
    return NO;
}


+ (id)shared
{
    static id shared = nil;
    static dispatch_once_t onceTokenCache;
    dispatch_once(&onceTokenCache, ^{ shared = [[[self class] alloc] init]; });
    return shared;
}


@end
