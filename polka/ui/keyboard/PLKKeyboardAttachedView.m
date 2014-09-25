//
//  PLKKeyboardAttachedView.m
//  App
//
//  Created by Alvaro Talavera on 6/17/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKKeyboardAttachedView.h"


static inline UIViewAnimationOptions AnimationOptionsForCurve(UIViewAnimationCurve curve)
{
	return curve << 16;
}

@implementation PLKKeyboardAttachedView
{
    UIScrollView *window;
    UIView *view;
    
    UITextView *textField;
    UIView *keyboard;
    
    int originalKeyboardY;
    
    BOOL isShowingKeyboard;
}


- (id)initWithView:(UIView *)targetView parentView:(UIScrollView *)parentView
{
    self = [super init];
    if (self) {
        view = targetView;
        window = parentView;
        
        isShowingKeyboard = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewWasSelected:) name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        
        targetView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [parentView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
        
        [self updateViewPosition:[self getViewOriginalPosition]];
    }
    return self;
}

- (void)invalidate
{
    keyboard.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    window = nil;
    view = nil;
    keyboard = nil;
    textField = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        UIView *observerView = object;
        float keyboardY = observerView.frame.origin.y;
        [self updateViewPosition:keyboardY];
    }
}


- (float)getViewOriginalPosition
{
    return (window.bounds.size.height);
}

- (void)updateViewPosition:(float)posY
{
    CGRect newFrame = view.frame;
    newFrame.origin.y = posY - view.frame.size.height;
    if(newFrame.origin.y > ([self getViewOriginalPosition] - view.bounds.size.height)) {
        newFrame.origin.y = [self getViewOriginalPosition] - view.bounds.size.height;
    }
    view.frame = newFrame;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(keyboardDidUpdatePositionWithViewPosition:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate keyboardDidUpdatePositionWithViewPosition:newFrame.origin.y];
        });
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(keyboardDidUpdatePosition:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate keyboardDidUpdatePosition:posY];
        });
    }
}

- (void)textViewWasSelected:(NSNotification *)notification
{
    textField = notification.object;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if(isShowingKeyboard) return;
    isShowingKeyboard = YES;
    keyboard.hidden = NO;
    
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    
    double keyboardTransitionDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
    
    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];
    
    originalKeyboardY = keyboardEndFrameWindow.origin.y;
    
    [UIView animateWithDuration:keyboardTransitionDuration
                          delay:0.0f
                        options:AnimationOptionsForCurve(keyboardTransitionAnimationCurve) | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self updateViewPosition:originalKeyboardY];
                     }
                     completion:^(__unused BOOL finished){
                         [self resetWindowOffset];
                     }];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    if(!keyboard) {
        keyboard = [[self class] getCurrentKeyboard];
        [keyboard addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    isShowingKeyboard = YES;
}

- (void)keyboardDidHide:(NSNotification *)notification
{   
    isShowingKeyboard = NO;
    [self resetWindowOffset];
    [self updateViewPosition:[self getViewOriginalPosition]];
}

- (void)resetWindowOffset
{
    float offsetY = (window.contentSize.height - (window.bounds.size.height - window.contentInset.bottom));
    [window setContentOffset:CGPointMake(0, offsetY) animated:YES];
}

/*
- (void)panGestureHandler:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(!isShowingKeyboard) return;
    
    UIView *gestureView = window;
    
    CGPoint location = [gestureRecognizer locationInView:gestureView];
    CGPoint velocity = [gestureRecognizer velocityInView:gestureView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (velocity.y > 0) {
            [self animateKeyboardOffscreen];
        } else {
            [self animateKeyboardReturnToOriginalPosition];
        }
        
        return;
    }
    
    CGFloat spaceAboveKeyboard = CGRectGetHeight(gestureView.bounds) - (CGRectGetHeight(keyboard.frame) + CGRectGetHeight(view.frame));
    if (location.y < spaceAboveKeyboard) {
        return;
    }
    
    CGRect newFrame = keyboard.frame;
    CGFloat newY = originalKeyboardY + (location.y - spaceAboveKeyboard);
    newY = MAX(newY, originalKeyboardY);
    newFrame.origin.y = newY;
    [keyboard setFrame: newFrame];
    
    [self updateViewPosition:newFrame.origin.y];
}

#pragma mark -

- (void)animateKeyboardOffscreen
{
    if(!isShowingKeyboard) return;
    
    CGRect newFrame = keyboard.frame;
    newFrame.origin.y = [self getViewOriginalPosition];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [keyboard setFrame: newFrame];
                         [self updateViewPosition:newFrame.origin.y];
                     }
     
                     completion:^(BOOL finished) {
                         keyboard.hidden = YES;
                         isShowingKeyboard = NO;
                         [textField resignFirstResponder];
                     }];
}

- (void)animateKeyboardReturnToOriginalPosition
{
    if(!isShowingKeyboard) return;
        
    [UIView beginAnimations:nil context:NULL];
    CGRect newFrame = keyboard.frame;
    newFrame.origin.y = originalKeyboardY;
    [keyboard setFrame: newFrame];
    [self updateViewPosition:newFrame.origin.y];
    [UIView commitAnimations];
    
    isShowingKeyboard = YES;
}
*/




@end
