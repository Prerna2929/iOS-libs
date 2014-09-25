//
//  PLKRequest.h
//  Polka Lab
//
//  Created by Ignacio Rojas on 3/20/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLKRequest.h"

@interface PLKRequest (Multi)

+ (void)requestWithURL:(NSString *)url
              atTarget:(id)target
                action:(SEL)action
                object:(id)object;

+ (void)requestWithURL:(NSString *)url
                   get:(NSDictionary *)get
              atTarget:(id)target
                action:(SEL)action
                object:(id)object;

+ (void)requestWithURL:(NSString *)url
                  post:(NSDictionary *)post
              atTarget:(id)target
                action:(SEL)action
                object:(id)object;

+ (void)requestWithURL:(NSString *)url
                   get:(NSDictionary *)get
                  post:(NSDictionary *)post
              atTarget:(id)target
                action:(SEL)action
                object:(id)object;

@end
