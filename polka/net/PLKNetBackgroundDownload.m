//
//  PLKNetBackgroundDownload.m
//  Tex
//
//  Created by Alvaro Talavera on 12/29/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKNetBackgroundDownload.h"

@interface FileDownloadInfo : NSObject

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) NSURLSessionDownloadTask *task;

@property (nonatomic, strong) NSData *data;

@property (nonatomic, strong) id object;

@property (nonatomic) double downloadProgress;

@property (nonatomic) BOOL isDownloading;

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) id<PLKNetBackgroundDownloadDelegate> delegate;

@end

@implementation FileDownloadInfo

- (instancetype)initWithSession:(NSURLSession *)session
{
    self = [super init];
    if (self) {
        self.downloadProgress   = 0.0;
        self.isDownloading      = NO;
        self.task               = nil;
        self.session            = session;
    }
    
    return self;
}

- (void)resume
{
    
    if (!self.isDownloading) {
        if (self.task == nil) {
            self.task = [self.session downloadTaskWithURL:self.url];
        }
        
        else {
            self.task = [self.session downloadTaskWithResumeData:self.data];
        }
        
        self.isDownloading = YES;
        [self.task resume];
    }
}

- (void)stop
{
    self.isDownloading = NO;
    [self.task cancelByProducingResumeData:^(NSData *resumeData) {
        if (resumeData != nil) {
            self.data = [[NSData alloc] initWithData:resumeData];
        }
    }];
}

@end




@implementation PLKNetBackgroundDownload
{
    NSMutableArray *tasks;
    NSURLSession *session;
}

+ (instancetype)shared
{
    static PLKNetBackgroundDownload *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = [[self alloc] init]; });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if(self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"cc.polka.PLKNetBackgroundDownload"];
        configuration.HTTPMaximumConnectionsPerHost = 5;
        [configuration setAllowsCellularAccess:YES];
        
        tasks   = [[NSMutableArray alloc] init];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    }
    
    return self;
}

- (void)downloadWithURL:(NSString *)url delegate:(id<PLKNetBackgroundDownloadDelegate>)delegate object:(id)object
{
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", [PLKRequest getPrefixURL], url];
    
    FileDownloadInfo *file = [[FileDownloadInfo alloc] initWithSession:session];
    file.url        = [NSURL URLWithString:fullURL];
    file.object     = object;
    file.delegate   = delegate;
    
    [tasks addObject:file];
    [file resume];
}

- (void)resumeAll
{
    for (FileDownloadInfo *file in tasks) {
        [file resume];
    }
}

- (void)stopAll
{
    for (FileDownloadInfo *file in tasks) {
        [file stop];
    }
}

- (void)cancelAll
{
    for (FileDownloadInfo *file in tasks) {
        [file.task cancel];
    }
    
    [tasks removeAllObjects];
}


#pragma mark - NSURLSession Delegate method implementation

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    for (FileDownloadInfo *file in tasks) {
        if(file.task.taskIdentifier == downloadTask.taskIdentifier) {
            if([file.delegate respondsToSelector:@selector(downloadDidCompleteWithLocation:object:)]) {
                [file.delegate downloadDidCompleteWithLocation:location object:file.object];
            }
            
            [tasks removeObject:file];
            break;
        }
    }
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error != nil) {
        NSLog(@"Download completed with error: %@", [error localizedDescription]);
    }
}


- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    if (totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown) {
        for (FileDownloadInfo *file in tasks) {
            if(file.task.taskIdentifier == downloadTask.taskIdentifier) {
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    file.downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
                    
                    if([file.delegate respondsToSelector:@selector(downloadDidUpdateProgress:object:)]) {
                        [file.delegate downloadDidUpdateProgress:file.downloadProgress object:file.object];
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
        
        if ([downloadTasks count] == 0) {
            if (self.completionHandler != nil) {
                
                void(^completionHandler)() = self.completionHandler;
                self.completionHandler = nil;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Call the completion handler to tell the system that there are no other background transfers.
                    completionHandler();
                    
                    /*
                     UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                     localNotification.alertBody = @"All files have been downloaded..";
                     [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                    */
                }];
            }
        }
    }];
}

@end
