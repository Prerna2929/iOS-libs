//
//  PLKRequest.m
//  Polka Lab.
//
//  Created by Ignacio Rojas on 3/20/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKRequest+Multi.h"

@implementation PLKRequest (Multi)

+ (void)requestWithURL:(NSString *)url
                   get:(NSDictionary *)get
                  post:(NSDictionary *)post
              atTarget:(id)target
                action:(SEL)action
                object:(id)object
{
    [PLKRequest requestWithURL:url get:get post:post completion:^(NSData *data) {
       
        IMP imp = [target methodForSelector:action];
        if(object!=nil) {
            void (*func)(id, SEL, NSData *, id) = (void *)imp;
            func(target, action, data, object);
        }
        else {
            void (*func)(id, SEL, NSData *) = (void *)imp;
            func(target, action, data);
        }
       
    }];
}

+ (void)requestWithURL:(NSString *)url
                   get:(NSDictionary *)get
              atTarget:(id)target
                action:(SEL)action
                object:(id)object
{
    [self requestWithURL:url get:get post:nil atTarget:target action:action object:object];
}


+ (void)requestWithURL:(NSString *)url
                  post:(NSDictionary *)post
              atTarget:(id)target
                action:(SEL)action
                object:(id)object
{
    [self requestWithURL:url get:nil post:post atTarget:target action:action object:object];
}

+ (void)requestWithURL:(NSString *)url
              atTarget:(id)target
                action:(SEL)action
                object:(id)object
{
    [self requestWithURL:url get:nil post:nil atTarget:target action:action object:object];
}


@end
