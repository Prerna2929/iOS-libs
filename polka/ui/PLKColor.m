//
//  PLKColor.m
//  LlevaUno
//
//  Created by Ignacio Rojas on 4/28/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKColor.h"

@implementation PLKColor

+ (UIColor *)colorWithHex:(UInt32)col
{
    return [self colorWithHex:col withAlpha:1.0];
}

+ (UIColor *)colorWithHex:(UInt32)col withAlpha:(float)alpha
{
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:alpha];
}

+ (UIColor *)defaultBlueColor
{
    return [self defaultBlueColorWithAlpha:1.0];
}

+ (UIColor *)defaultBlueColorWithAlpha:(float)alpha
{
    return [UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:alpha];
}


@end
