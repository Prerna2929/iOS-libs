//
//  PLKSocketClient.m
//  App
//
//  Created by Alvaro Talavera on 6/10/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKSocketClient.h"

#define _INPUT_BUFFER_SIZE (1024*4)
#define _SOCKET_ENCODING (NSUTF8StringEncoding)

@implementation PLKSocketClient
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    NSMutableData *outputBuffer;
    NSMutableString *inputBuffer;
    
    NSTimer *timer;
}

- (id)initWithHost:(NSString *)host port:(NSInteger)port
{
    self = [super init];
    if(self) {
        self.host = host;
        self.port = port;
        
        self.isAlive = NO;
    }
    
    return self;
}

- (void)enableHeartbeat
{
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    timer = [NSTimer timerWithTimeInterval:15.0 target:self selector:@selector(heartbeatLoop) userInfo:nil repeats:YES];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
    [runloop addTimer:timer forMode:UITrackingRunLoopMode];
}

- (void)connect
{
    self.isAlive = NO;
    outputBuffer  = [[NSMutableData alloc ] init];
    inputBuffer   = [[NSMutableString alloc] init];
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.host, (int)self.port, &readStream, &writeStream);
    inputStream = (__bridge_transfer __strong NSInputStream *)readStream;
    outputStream = (__bridge_transfer __strong NSOutputStream *)writeStream;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
}

- (void)close
{
    self.isAlive = NO;
    
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream close];
    [outputStream close];
    
    inputStream = nil;
    outputStream = nil;
    
    outputBuffer = nil;
    
    if(timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)write:(NSString *)string
{
    @synchronized(outputBuffer) {
        [outputBuffer appendData:[string dataUsingEncoding:_SOCKET_ENCODING]];
    }
    
    @synchronized(outputStream) {
        [self processOutput];
    }
}

- (void)writeLine:(NSString *)string
{
    string = [NSString stringWithFormat:@"%@\r\n", string];  // 0x00];
	[self write:string];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
            
		case NSStreamEventOpenCompleted:
            if(aStream == outputStream) {
                self.isAlive = YES;
                if([self.delegate respondsToSelector:@selector(socketDidConnect:)]) {
                    [self.delegate socketDidConnect:YES];
                }
            }
			break;
            
		case NSStreamEventHasBytesAvailable:
            if (aStream == inputStream) {
                [self processInput];
            }
			break;
        
        case NSStreamEventHasSpaceAvailable:
            if(aStream == outputStream) {                
                @synchronized(outputStream) {
                    [self processOutput];
                }
            }
            break;
            
		case NSStreamEventErrorOccurred:
            [self close];
            
            if([self.delegate respondsToSelector:@selector(socketDidDisconnectWithError:)]) {
                [self.delegate socketDidDisconnectWithError:[aStream streamError]];
            }
            
			break;
            
		case NSStreamEventEndEncountered:
            [self close];
            
            if([self.delegate respondsToSelector:@selector(socketDidDisconnectWithError:)]) {
                [self.delegate socketDidDisconnectWithError:[aStream streamError]];
            }
            
			break;
            
		default:
			NSLog(@"Unknown event");
            break;
	}
}

// Called in response to a NSStreamEventHasBytesAvailable event to read the data
// from the input stream and process any commands in the data.

- (void)processInput
{
    uint8_t buffer[_INPUT_BUFFER_SIZE];
    int bytesRead = 0;

    bytesRead = (int)[inputStream read:buffer maxLength:sizeof(buffer)];
    
    if (bytesRead == 0) {
        [self close];
        
        if([self.delegate respondsToSelector:@selector(socketDidDisconnectWithError:)]) {
            [self.delegate socketDidDisconnectWithError:[inputStream streamError]];
        }
    }
    
    else if (bytesRead < 0) {
        NSLog(@"-- R ERRF -- ");
    }
    
    else {
        NSData *data = [NSData dataWithBytes:buffer length:bytesRead];
        NSString *output = [[NSString alloc] initWithData:data encoding:_SOCKET_ENCODING];
        [inputBuffer appendString:output];
        
        while (1) {
            NSRange range = [inputBuffer rangeOfString:@"\r\n"];
            if (range.location != NSNotFound) {
                NSString *line = [inputBuffer substringWithRange:NSMakeRange(0, range.location)];
                [inputBuffer deleteCharactersInRange:NSMakeRange(0, range.location + range.length)];
                
                // if NOT heartbeat server response..
                if (![line isEqualToString:@"pong"]) {
                    if([self.delegate respondsToSelector:@selector(socketDidReceive:)]) {
                        [self.delegate socketDidReceive:line];
                    }
                }
            }
            
            break;
        }
    }
}

// Called in response to a NSStreamEventHasSpaceAvailable event
// (or if such an event was deferred) to start sending data to the output stream.
- (void)processOutput
{
    if([outputStream hasSpaceAvailable]) {
        NSInteger bytesWritten;
        
        if ([outputBuffer length] != 0) {
            
            bytesWritten = [outputStream write:[outputBuffer bytes] maxLength:[outputBuffer length]];
            
            if (bytesWritten <= 0) {
                NSLog(@"-- W ERRF -- ");
            }
            
            else {
                [outputBuffer replaceBytesInRange:NSMakeRange(0, bytesWritten) withBytes:NULL length:0];
            }
        }
    }
}

- (void)heartbeatLoop
{
    if(self.isAlive) {
        [self writeLine:@"ping"];
    }
}

@end
