//
//  PLKButtonBar.m
//  App
//
//  Created by Alvaro Talavera on 5/27/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKButtonBar.h"

@implementation PLKButtonBar

+ (UIBarButtonItem *)navigationBackButton:(id)target selector:(SEL)selector
{
    return [self navigationButtonTitle:@"Back" target:target selector:selector];
}


+ (UIBarButtonItem *)navigationButtonTitle:(NSString *)title target:(id)target selector:(SEL)selector
{
    return [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
}

@end
