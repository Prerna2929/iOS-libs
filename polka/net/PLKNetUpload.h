//
//  PLKNetUpload.h
//  Tex
//
//  Created by Alvaro Talavera on 8/8/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@protocol PLKNetUploadDelegate <NSObject>

- (void)uploadDidCompleteWithData:(NSData *)data object:(id)object;

@optional

- (void)uploadDidUpdateProgress;

@end

@interface PLKNetUpload : NSObject <NSURLSessionDelegate>

@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSURLSessionUploadTask *task;
@property (nonatomic, strong) id<PLKNetUploadDelegate> delegate;

+ (id)uploadWithURL:(NSString *)url paths:(NSArray *)paths delegate:(id<PLKNetUploadDelegate>)delegate object:(id)object;

+ (id)uploadWithURL:(NSString *)url get:(NSDictionary *)get paths:(NSArray *)paths delegate:(id<PLKNetUploadDelegate>)delegate object:(id)object;

- (id)initWithURL:(NSString *)url get:(NSDictionary *)get paths:(NSArray *)paths delegate:(id<PLKNetUploadDelegate>)delegate object:(id)object;

@end
