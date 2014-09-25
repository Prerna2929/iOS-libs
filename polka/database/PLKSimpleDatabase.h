//
//  PLKDatabase.h
//  Mazen
//
//  Created by Alvaro Talavera on 10/5/12.
//  Copyright (c) 2012 Alvaro Talavera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLKSimpleDatabase : NSObject

+ (void)set:(NSString *)key value:(NSString *)value;

+ (NSString *)get:(NSString *)key;

@end
