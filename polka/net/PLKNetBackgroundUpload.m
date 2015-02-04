//
//  PLKNetBackgroundUpload.m
//  Tex
//
//  Created by Alvaro Talavera on 12/29/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKNetBackgroundUpload.h"

@interface FileUploadInfo : NSObject

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) NSURLSessionUploadTask *task;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) id object;

@property (nonatomic) double uploadProgress;

@property (nonatomic) BOOL isUploading;

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) id<PLKNetBackgroundUploadDelegate> delegate;

@end

@implementation FileUploadInfo

- (instancetype)initWithSession:(NSURLSession *)session
{
    self = [super init];
    if (self) {
        self.uploadProgress   = 0.0;
        self.isUploading      = NO;
        self.task             = nil;
        self.session          = session;
    }
    
    return self;
}

- (void)resume
{
    if (!self.isUploading) {
        if (self.task == nil) {
            NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
            NSURL *dataURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", self.content]];
            self.task = [self.session uploadTaskWithRequest:request fromFile:dataURL];
        }
        
        self.isUploading = YES;
        [self.task resume];
    }
}

- (void)cancel
{
    self.isUploading = NO;
    [self.task cancel];
}

@end

@implementation PLKNetBackgroundUpload
{
    NSMutableArray *tasks;
    NSURLSession *session;
}


+ (instancetype)shared
{
    static PLKNetBackgroundUpload *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = [[self alloc] init]; });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if(self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"cc.polka.PLKNetBackgroundUpload"];
        configuration.HTTPMaximumConnectionsPerHost = 5;
        [configuration setAllowsCellularAccess:YES];
        
        tasks   = [[NSMutableArray alloc] init];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    }
    
    return self;
}

- (void)uploadWithURL:(NSString *)url content:(NSString *)content delegate:(id<PLKNetBackgroundUploadDelegate>)delegate object:(id)object
{
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", [PLKRequest getPrefixURL], url];
    
    FileUploadInfo *file = [[FileUploadInfo alloc] initWithSession:session];
    file.url        = [NSURL URLWithString:fullURL];
    file.object     = object;
    file.delegate   = delegate;
    file.content    = content;
    
    [tasks addObject:file];
    [file resume];
}

- (void)resumeAll
{
    for (FileUploadInfo *file in tasks) {
        [file resume];
    }
}

- (void)cancelAll
{
    for (FileUploadInfo *file in tasks) {
        [file.task cancel];
    }
    
    [tasks removeAllObjects];
}

#pragma mark - NSURLSession Delegate method implementation


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    BOOL success = YES;
    
    if (error != nil) {
        NSLog(@"Upload completed with error: %@", [error localizedDescription]);
        success = NO;
    }
    
    for (FileUploadInfo *file in tasks) {
        if(file.task.taskIdentifier == task.taskIdentifier) {
            if([file.delegate respondsToSelector:@selector(uploadDidCompleteWithSuccess:object:)]) {
                [file.delegate uploadDidCompleteWithSuccess:success object:file.object];
            }
            
            [tasks removeObject:file];
            break;
        }
    }
}


- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    if (totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown) {
        for (FileUploadInfo *file in tasks) {
            if(file.task.taskIdentifier == downloadTask.taskIdentifier) {
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    file.uploadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
                    
                    if([file.delegate respondsToSelector:@selector(uploadDidUpdateProgress:object:)]) {
                        [file.delegate uploadDidUpdateProgress:file.uploadProgress object:file.object];
                    }
                }];
                
                break;
            }
        }
    }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)sessionTask
{
    [sessionTask getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        
        if ([uploadTasks count] == 0) {
            if (self.completionHandler != nil) {
                
                void(^completionHandler)() = self.completionHandler;
                self.completionHandler = nil;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Call the completion handler to tell the system that there are no other background transfers.
                    completionHandler();
                    
                    /*
                     UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                     localNotification.alertBody = @"All files have been uploaded..";
                     [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                     */
                }];
            }
        }
    }];
}

@end
