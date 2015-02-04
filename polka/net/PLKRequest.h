//
//  PLKNetInline.h
//  App
//
//  Created by Alvaro Talavera on 5/22/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PLKRequestCompletionHandler)(NSData *data);

@interface PLKRequest : NSObject

+ (void)setPrefixURL:(NSString *)url;

+ (NSString *)getPrefixURL;

+ (id)requestWithURL:(NSString *)url completion:(PLKRequestCompletionHandler)completion;

+ (id)requestWithURL:(NSString *)url get:(NSDictionary *)get completion:(PLKRequestCompletionHandler)completion;

+ (id)requestWithURL:(NSString *)url post:(NSDictionary *)post completion:(PLKRequestCompletionHandler)completion;

+ (id)requestWithURL:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post completion:(PLKRequestCompletionHandler)completion;


- (id)initWithURL:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post completion:(PLKRequestCompletionHandler)completion;

+ (NSURL *)getFormedURLWithParams:(NSString *)url getDictionary:(NSDictionary *)get;

@end
