//
//  PLKKeyboard.m
//  App
//
//  Created by Alvaro Talavera on 6/17/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKKeyboard.h"
#import "PLKMacros.h"

@implementation PLKKeyboard

+ (UIView *)getCurrentKeyboard
{
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    for (int i = 0; i < [tempWindow.subviews count]; i++) {
        UIView *possibleKeyboard = [tempWindow.subviews objectAtIndex:i];
        
        if(_PLK_IS_OS_8_OR_LATER) { // iOS 8
            possibleKeyboard = [possibleKeyboard.subviews objectAtIndex:0];
            if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIInputSetHostView")]) {
                return possibleKeyboard;
            }
            
        }
        else {
            if ([possibleKeyboard isKindOfClass:NSClassFromString(@"UIPeripheralHostView")]) {
                return possibleKeyboard;
            }
        }
    }
    
    return nil;
}

@end
