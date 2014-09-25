//
//  PLKAlert.m
//  LlevaUno
//
//  Created by Ignacio Rojas on 4/28/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKAlert.h"
#import "PLKCache.h"
#import "PLKColor.h"

static UIAlertView *m_loader;
static UIViewController *m_holder;

static UIView *_inline_view;
static UIWindow *_inline_window;

@implementation PLKAlert

+ (AVAudioPlayer *)alertAudioPlayer
{
    AVAudioPlayer *audioPlayer = [[PLKCache sharedCache] objectForKey:@"alertAudioPlayer"];
    if(audioPlayer) return audioPlayer;
    
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"alarm"
                                         ofType:@"wav"]];
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    
    [[PLKCache sharedCache] setObject:audioPlayer forKey:@"alertAudioPlayer"];
    
    return audioPlayer;
}

+ (void)loaderShow
{
    if(m_loader != nil) return;
    
    m_loader = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Loading", nil)
                                          message:NSLocalizedString(@"Please wait", nil)
                                         delegate:nil
                                cancelButtonTitle:nil
                                otherButtonTitles:nil];
    
    [m_loader show];
}

+ (void)loaderHide
{
    if(m_loader == nil) return;
    [m_loader dismissWithClickedButtonIndex:0 animated:YES];
    m_loader = nil;
}

+ (void)promptViewWithDelegate:(id<UIAlertViewDelegate>)delegate title:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:delegate
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                              otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
    
    [alertView show];
}

+ (void)alertViewWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    
    [alertView show];
}

+ (void)alertViewWithSoundAndTitle:(NSString *)title message:(NSString *)message
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    
    
    [[self alertAudioPlayer] play];
    
    [alertView show];
    
}

+ (void)alertViewErrorWithMessage:(NSString *)message
{
    [self alertViewWithTitle:@"Error" message:message];
}

+ (void)alertViewFatalErrorMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    
    [alertView show];
}

+ (void)alertInlineWithMessage:(NSString *)message color:(UIColor *)color
{
    UIView *errorInlineView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 20)];
    [errorInlineView setBackgroundColor:color];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [messageLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [messageLabel setTextColor:[UIColor whiteColor]];
    [messageLabel setAdjustsFontSizeToFitWidth:YES];
    [messageLabel setMinimumScaleFactor:0.7];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setText:message];
    [errorInlineView addSubview:messageLabel];
    
    
    __block UIWindow *statusWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusWindow.windowLevel = UIWindowLevelStatusBar;
    statusWindow.hidden = NO;
    statusWindow.backgroundColor = [UIColor clearColor];
    
    [statusWindow addSubview:errorInlineView];
    [statusWindow makeKeyAndVisible];
    
    
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [errorInlineView setFrame:CGRectMake(0, 0, 320, 20)];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.5
                                               delay:2
                                             options: UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              [errorInlineView setFrame:CGRectMake(0, -20, 320, 20)];
                                          }
                                          completion:^(BOOL finished){
                                              [errorInlineView removeFromSuperview];
                                              statusWindow = nil;
                                          }];
                     }];
}



+ (void)alertInlineWithErrorMessage:(NSString *)message
{
    [self alertInlineWithMessage:message color:[PLKColor colorWithHex:0xFF0000]];
}


+ (void)loaderInlineShow:(NSString *)message color:(UIColor *)color
{
    if(_inline_view != nil) return;
    
    _inline_view = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 20)];
    [_inline_view setBackgroundColor:color];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [messageLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [messageLabel setTextColor:[UIColor whiteColor]];
    [messageLabel setAdjustsFontSizeToFitWidth:YES];
    [messageLabel setMinimumScaleFactor:0.7];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setText:message];
    [_inline_view addSubview:messageLabel];
    
    
    _inline_window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    _inline_window.windowLevel = UIWindowLevelStatusBar;
    _inline_window.hidden = NO;
    _inline_window.backgroundColor = [UIColor clearColor];
    
    [_inline_window addSubview:_inline_view];
    [_inline_window makeKeyAndVisible];
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [_inline_view setFrame:CGRectMake(0, 0, 320, 20)];
                     }
                     completion:nil];
}

+ (void)loaderInlineShow:(NSString *)message
{
    [self loaderInlineShow:message color:[UIColor whiteColor]];
}

+ (void)loaderInlineHide
{
    if(_inline_view == nil) return;
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [_inline_view setFrame:CGRectMake(0, -20, 320, 20)];
                     }
                     completion:^(BOOL finished){
                         [_inline_view removeFromSuperview];
                         _inline_window = nil;
                         _inline_view = nil;
                     }];
}



+ (UIViewController *)getHolder
{
    return m_holder;
}

@end
