//
//  PLKColor.h
//  LlevaUno
//
//  Created by Ignacio Rojas on 4/28/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLKColor : NSObject

+ (UIColor *)colorWithHex:(UInt32)col;

+ (UIColor *)colorWithHex:(UInt32)col withAlpha:(float)alpha;

+ (UIColor *)defaultBlueColor;

+ (UIColor *)defaultBlueColorWithAlpha:(float)alpha;

@end
