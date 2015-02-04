//
//  PLKNetBackgroundDownload.h
//  Tex
//
//  Created by Alvaro Talavera on 12/29/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PLKNetBackgroundDownloadDelegate <NSObject>

- (void)downloadDidCompleteWithLocation:(NSURL *)location object:(id)object;

@optional

- (void)downloadDidUpdateProgress:(double)downloadProgress object:(id)object;

@end

@interface PLKNetBackgroundDownload : NSObject <NSURLSessionDelegate>

@property (nonatomic, copy) void(^completionHandler)();

+ (instancetype)shared;

- (void)downloadWithURL:(NSString *)url delegate:(id<PLKNetBackgroundDownloadDelegate>)delegate object:(id)object;

- (void)resumeAll;

- (void)stopAll;

- (void)cancelAll;

@end
