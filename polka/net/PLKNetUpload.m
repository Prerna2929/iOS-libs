//
//  PLKNetUpload.m
//  Tex
//
//  Created by Alvaro Talavera on 8/8/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKNetUpload.h"
#import "PLKRequest.h"

@implementation PLKNetUpload

+ (id)uploadWithURL:(NSString *)url paths:(NSArray *)paths delegate:(id<PLKNetUploadDelegate>)delegate object:(id)object;
{
    return [[self alloc] initWithURL:url get:nil paths:paths delegate:delegate object:object];
}

+ (id)uploadWithURL:(NSString *)url get:(NSDictionary *)get paths:(NSArray *)paths delegate:(id<PLKNetUploadDelegate>)delegate object:(id)object;
{
    return [[self alloc] initWithURL:url get:get paths:paths delegate:delegate object:object];
}

- (id)initWithURL:(NSString *)url get:(NSDictionary *)get paths:(NSArray *)paths delegate:(id<PLKNetUploadDelegate>)delegate object:(id)object;
{
    self = [super init];
    if(self) {
        self.delegate = delegate;
        self.object = object;
        
        NSString *fullURL = [NSString stringWithFormat:@"%@%@", [PLKRequest getPrefixURL], url];
        NSURL *urlString = [PLKRequest getFormedURLWithParams:fullURL getDictionary:(NSDictionary *)get];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString];
        [request setHTTPMethod:@"POST"];
        NSString *boundary = [self boundaryString];
        [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
        
        NSData *data = [self createBodyWithBoundary:boundary paths:paths];
                
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [configuration setAllowsCellularAccess:YES];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        self.task = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error) {
                NSLog(@"Upload error: %@", [error debugDescription]);
                if([self.delegate respondsToSelector:@selector(uploadDidCompleteWithData:object:)]) {
                    [self.delegate uploadDidCompleteWithData:nil object:self.object];
                }
            }
            else {
                if([self.delegate respondsToSelector:@selector(uploadDidCompleteWithData:object:)]) {
                    [self.delegate uploadDidCompleteWithData:data object:self.object];
                }
            }
        }];
        
        [self.task resume];
    }
    
    return self;
}

- (NSData *)createBodyWithBoundary:(NSString *)boundary paths:(NSArray *)paths
{
    NSMutableData *body = [NSMutableData data];
    uint i = 0;
    for (id path in paths) {
        NSData *data;
        NSString *filename;
        
        if([path isKindOfClass:[NSString class]]) {
            data        = [NSData dataWithContentsOfFile:path];
            filename    = [path lastPathComponent];
        }
        
        else if([path isKindOfClass:[UIImage class]]) {
            data        = UIImageJPEGRepresentation(path, 1);
            filename    = [NSString stringWithFormat:@"%@.jpg", [PLKHash uuid]];
        }
        
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%i\"; filename=\"%@\"\r\n", i, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", [self mimeTypeForPath:filename]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        i++;
    }

    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return body;
}

- (NSString *)boundaryString
{
    CFUUIDRef  uuid;
    NSString  *uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
    assert(uuidStr != NULL);
    
    CFRelease(uuid);
    
    return [NSString stringWithFormat:@"Boundary-%@", uuidStr];
}

- (NSString *)mimeTypeForPath:(NSString *)path
{
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}


@end
