//
//  PLKSocketClient.h
//  App
//
//  Created by Alvaro Talavera on 6/10/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PLKSocketClientDelegate <NSObject>

- (void)socketDidConnect:(BOOL)connected;

- (void)socketDidReceive:(NSString *)data;

@optional

- (void)socketDidDisconnectWithError:(NSError *)error;

@end

@interface PLKSocketClient : NSObject <NSStreamDelegate>

@property (strong, nonatomic) id<PLKSocketClientDelegate> delegate;
@property (strong, nonatomic) NSString *host;
@property (assign, nonatomic) NSInteger port;
@property (assign, nonatomic) BOOL isAlive;


- (id)initWithHost:(NSString *)host port:(NSInteger)port;

- (void)connect;

- (void)enableHeartbeat;

- (void)close;

- (void)write:(NSString *)string;

- (void)writeLine:(NSString *)string;

@end
