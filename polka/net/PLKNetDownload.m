//
//  PLKNetDownload.m
//  Tex
//
//  Created by Alvaro Talavera on 8/10/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKNetDownload.h"
#import "PLKRequest.h"

@implementation PLKNetDownload


+ (id)downloadWithURL:(NSString *)url delegate:(id<PLKNetDownloadDelegate>)delegate object:(id)object
{
    return [[self alloc] initWithURL:url get:nil delegate:delegate object:object];
}

+ (id)downloadWithURL:(NSString *)url get:(NSDictionary *)get delegate:(id<PLKNetDownloadDelegate>)delegate object:(id)object
{
    return [[self alloc] initWithURL:url get:get delegate:delegate object:object];
}

- (id)initWithURL:(NSString *)url get:(NSDictionary *)get delegate:(id<PLKNetDownloadDelegate>)delegate object:(id)object
{
    self = [super init];
    if(self) {
        self.delegate = delegate;
        self.object = object;
        
        NSString *fullURL = [NSString stringWithFormat:@"%@%@", [PLKRequest getPrefixURL], url];
        NSURL *urlString = [PLKRequest getFormedURLWithParams:fullURL getDictionary:(NSDictionary *)get];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];

        self.task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            if(error) {
                if([self.delegate respondsToSelector:@selector(downloadDidCompleteWithLocation:object:)]) {
                    [self.delegate downloadDidCompleteWithLocation:nil object:self.object];
                }
            }
            else {
                if([self.delegate respondsToSelector:@selector(downloadDidCompleteWithLocation:object:)]) {
                    [self.delegate downloadDidCompleteWithLocation:location object:self.object];
                }
            }
        }];
        
        [self.task resume];
    }
    
    return self;
}


- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"downloadTask: totalBytesWritten:%lli  |  totalBytesExpectedToWrite:%lli", totalBytesWritten, totalBytesExpectedToWrite);
    
    if([self.delegate respondsToSelector:@selector(downloadDidUpdateProgress)]) {
        // [self.delegate downloadDidUpdateProgress];
    }
}




- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    
}

@end
