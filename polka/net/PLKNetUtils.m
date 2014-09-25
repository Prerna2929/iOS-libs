//
//  PLKNetUtils.m
//  App
//
//  Created by Alvaro Talavera on 6/12/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKNetUtils.h"
#include <unistd.h>
#include <netdb.h>

@implementation PLKNetUtils

+ (void)isInternetAvailable:(void(^)(BOOL available))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        struct addrinfo *res = NULL;
        int s = getaddrinfo("apple.com", NULL, NULL, &res);
        __block bool network_ok = (s == 0 && res != NULL);
        freeaddrinfo(res);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(network_ok) {
                block(YES);
            }
            else {
                block(NO);
            }
        });
    });
}



@end
