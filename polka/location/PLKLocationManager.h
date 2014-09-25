//
//  LocationManager.h
//  Taxipar
//
//  Created by Alvaro Talavera on 2/25/14.
//  Copyright (c) 2014 Alvaro Talavera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol PLKLocationManagerDelegate <NSObject>

- (void)locationUpdate:(CLLocation *)location;

@optional

- (void)locationError:(NSError *)error;

@end


@interface PLKLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) id<PLKLocationManagerDelegate> delegate;

+ (PLKLocationManager *)shared;

- (void)setup;

- (void)start;

- (void)stop;

@end
