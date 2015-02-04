//
//  PLKNetBackgroundUpload.h
//  Tex
//
//  Created by Alvaro Talavera on 12/29/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PLKNetBackgroundUploadDelegate <NSObject>

- (void)uploadDidCompleteWithSuccess:(BOOL)success object:(id)object;

@optional

- (void)uploadDidUpdateProgress:(double)uploadProgress object:(id)object;

@end

@interface PLKNetBackgroundUpload : NSObject <NSURLSessionDelegate>

@property (nonatomic, copy) void(^completionHandler)();

+ (instancetype)shared;

- (void)uploadWithURL:(NSString *)url content:(id)content delegate:(id<PLKNetBackgroundUploadDelegate>)delegate object:(id)object;

- (void)resumeAll;

- (void)cancelAll;

@end
