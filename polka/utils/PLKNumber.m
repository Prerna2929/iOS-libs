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
    return [self stringWithDecimalSeparator:number groupingSeparator:@"," decimalSeparator:@"."];
}

+ (NSString *)stringWithDecimalSeparator:(NSString *)number
                       groupingSeparator:(NSString *)groupingSeparator
                       decimalSeparator:(NSString *)decimalSeparator
{
    NSNumber *aux = [NSNumber numberWithInt:[number doubleValue]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setDecimalSeparator:decimalSeparator];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    return [formatter stringFromNumber:aux];
}

@end
