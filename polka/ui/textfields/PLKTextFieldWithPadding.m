//
//  PLKTextFieldWithPadding.m
//  pictrip
//
//  Created by Alvaro Talavera on 11/25/13.
//  Copyright (c) 2013 Alvaro Talavera. All rights reserved.
//

#import "PLKTextFieldWithPadding.h"

@implementation PLKTextFieldWithPadding

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 8,
                      bounds.size.width - 20, bounds.size.height - 16);
}
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

@end
