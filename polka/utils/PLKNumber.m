//
//  PLKNumber.m
//  Polka Lab
//
//  Created by Ignacio Rojas on 3/25/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKNumber.h"

@implementation PLKNumber

+ (NSString *)stringWithDecimalSeparator:(NSString *)number
{
    NSNumber *aux = [NSNumber numberWithInt:[number doubleValue]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setGroupingSeparator:@"."];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setDecimalSeparator:@","];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    return [formatter stringFromNumber:aux];
}

@end
