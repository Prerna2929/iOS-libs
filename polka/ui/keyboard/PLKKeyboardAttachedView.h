//
//  PLKKeyboardAttachedView.h
//  App
//
//  Created by Alvaro Talavera on 6/17/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PLKKeyboardAttachedViewDelegate <NSObject>

- (void)keyboardDidUpdatePositionWithViewPosition:(float)ypos;

@optional

- (void)keyboardDidUpdatePosition:(float)ypos;

@end

@interface PLKKeyboardAttachedView : PLKKeyboard <UIGestureRecognizerDelegate>

@property (nonatomic, strong) id<PLKKeyboardAttachedViewDelegate> delegate;

- (id)initWithView:(UIView *)targetView parentView:(UIScrollView *)parentView;

- (void)invalidate;

@end
