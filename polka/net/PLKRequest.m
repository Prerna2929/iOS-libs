//
//  PLKNetInline.m
//  App
//
//  Created by Alvaro Talavera on 5/22/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKRequest.h"

static NSString *PLKRequestPrefixURL = @"";

@implementation PLKRequest

+ (void)setPrefixURL:(NSString *)url
{
    PLKRequestPrefixURL = url;
}

+ (NSString *)getPrefixURL
{
    return PLKRequestPrefixURL;
}

+ (id)requestWithURL:(NSString *)url completion:(PLKRequestCompletionHandler)completion
{
    return [[self alloc] initWithURL:url get:nil post:nil completion:completion];
}

+ (id)requestWithURL:(NSString *)url get:(NSDictionary *)get completion:(PLKRequestCompletionHandler)completion
{
    return [[self alloc] initWithURL:url get:get post:nil completion:completion];
}

+ (id)requestWithURL:(NSString *)url post:(NSDictionary *)post completion:(PLKRequestCompletionHandler)completion;
{
    return [[self alloc] initWithURL:url get:nil post:post completion:completion];
}

+ (id)requestWithURL:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post completion:(PLKRequestCompletionHandler)completion
{
    return [[self alloc] initWithURL:url get:get post:post completion:completion];
}


- (id)initWithURL:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post completion:(PLKRequestCompletionHandler)completion;
{
    self = [self init];
    if(self) {
        NSString *fullURL = [NSString stringWithFormat:@"%@%@", PLKRequestPrefixURL, url];
        NSURL *urlString = [[self class] getFormedURLWithParams:fullURL getDictionary:(NSDictionary *)get];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:urlString];
        
        NSString *params = [self parsePOSTBody:post];
        if(params) {
            [urlRequest setHTTPMethod:@"post"];
            [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [[session dataTaskWithRequest:urlRequest
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        if(error) {
                            if(completion) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    completion(nil);
                                });
                            }
                        }
                        else {
                            if(completion) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    completion(data);
                                });
                            }
                        }
                    }] resume];
    }
    
    return self;
}

+ (NSURL *)getFormedURLWithParams:(NSString *)url getDictionary:(NSDictionary *)get
{
    NSURLComponents *components = [NSURLComponents componentsWithString:url];
    if(get) {
        NSString *query = [self queryStringWithParams:get];
        components.query = query;
    }
    
    return [components URL];
}

- (NSString *)parsePOSTBody:(NSDictionary *)post
{
    if(!post) return nil;
    return [[self class] queryStringWithParams:post];
}


+ (NSString *)queryStringWithParams:(NSDictionary *)params
{
    NSMutableArray *query = [NSMutableArray array];
    if ([params count]) {
        for (id key in params) {
            NSString *param = [NSString stringWithFormat:@"%@=%@", key, [self urlEncode:params[key]]];
            [query addObject:param];
        }
    }
    return [query componentsJoinedByString:@"&"];
}

+ (id)urlEncode:(id)value
{
    if([value isKindOfClass:[NSString class]]) {
        return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                     (CFStringRef)value,
                                                                                     NULL,
                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                     kCFStringEncodingUTF8));
    }
    
    return value;
}

@end
