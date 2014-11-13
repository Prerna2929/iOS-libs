//
//  PLKButtonBar.h
//  App
//
//  Created by Alvaro Talavera on 5/27/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLKButtonBar : NSObject

+ (UIBarButtonItem *)navigationBackButton:(id)target selector:(SEL)selector;

+ (UIBarButtonItem *)navigationButtonTitle:(NSString *)title target:(id)target selector:(SEL)selector;

@end
