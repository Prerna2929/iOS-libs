//
//  PLKAlert.h
//  LlevaUno
//
//  Created by Ignacio Rojas on 4/28/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PLKAlert : NSObject

+ (AVAudioPlayer *) alertAudioPlayer;

+ (void)loaderShow;

+ (void)loaderHide;

+ (void)promptViewWithDelegate:(id<UIAlertViewDelegate>)delegate title:(NSString *)title message:(NSString *)message;

+ (void)alertViewWithTitle:(NSString *)title message:(NSString *)message;

+ (void)alertViewErrorWithMessage:(NSString *)message;

+ (void)alertViewFatalErrorMessage:(NSString *)message;

+ (void)alertInlineWithMessage:(NSString *)message color:(UIColor *)color;

+ (void)alertInlineWithErrorMessage:(NSString *)message;

+ (void)loaderInlineShow:(NSString *)message color:(UIColor *)color;

+ (void)loaderInlineShow:(NSString *)message;

+ (void)loaderInlineHide;

+ (UIViewController *)getHolder;

@end
