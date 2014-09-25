//
//  PLKTextView.m
//  App
//
//  Created by Alvaro Talavera on 6/17/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKTextView.h"

@implementation PLKTextView

// Get the corect size of a UiTextView
// http://stackoverflow.com/questions/19837178/resize-uitextview-according-to-its-content-in-ios7

+ (CGRect)contentSizeRectForTextView:(UITextView *)textView
{
    [textView.layoutManager ensureLayoutForTextContainer:textView.textContainer];
    CGRect textBounds = [textView.layoutManager usedRectForTextContainer:textView.textContainer];
    CGFloat width =  (CGFloat)ceil(textBounds.size.width + textView.textContainerInset.left + textView.textContainerInset.right);
    CGFloat height = (CGFloat)ceil(textBounds.size.height + textView.textContainerInset.top + textView.textContainerInset.bottom);
    return CGRectMake(0, 0, width, height);
}

@end
