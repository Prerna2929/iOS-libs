//
//  PLKNetUtils.h
//  App
//
//  Created by Alvaro Talavera on 6/12/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLKNetUtils : NSObject

+ (void)isInternetAvailable:(void(^)(BOOL available))block;

@end
