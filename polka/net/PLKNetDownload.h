//
//  PLKNetDownload.h
//  Tex
//
//  Created by Alvaro Talavera on 8/10/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@protocol PLKNetDownloadDelegate <NSObject>

- (void)downloadDidCompleteWithLocation:(NSURL *)location object:(id)object;

@optional

- (void)downloadDidUpdateProgress;

@end


@interface PLKNetDownload : NSObject <NSURLSessionDownloadDelegate, NSURLSessionDelegate>

@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) id<PLKNetDownloadDelegate> delegate;

+ (id)downloadWithURL:(NSString *)url delegate:(id<PLKNetDownloadDelegate>)delegate object:(id)object;

+ (id)downloadWithURL:(NSString *)url get:(NSDictionary *)get delegate:(id<PLKNetDownloadDelegate>)delegate object:(id)object;

- (id)initWithURL:(NSString *)url get:(NSDictionary *)get delegate:(id<PLKNetDownloadDelegate>)delegate object:(id)object;

@end
