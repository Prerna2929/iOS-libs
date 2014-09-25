//
//  PLKDate.m
//  LlevaUno
//
//  Created by Ignacio Rojas on 4/2/14.
//  Copyright (c) 2014 Polka. All rights reserved.
//

#import "PLKDate.h"

@implementation PLKDate

+ (NSDate *)initWithString:(NSString *)date
{
    NSDateFormatter *datef = [[NSDateFormatter alloc] init];
    datef.timeStyle = NSDateFormatterNoStyle;
    datef.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [datef dateFromString:date];
}


@end
