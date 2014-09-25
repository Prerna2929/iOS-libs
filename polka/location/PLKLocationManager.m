//
//  LocationManager.m
//  Taxipar
//
//  Created by Alvaro Talavera on 2/25/14.
//  Copyright (c) 2014 Alvaro Talavera. All rights reserved.
//

#import "PLKLocationManager.h"


@implementation PLKLocationManager
{
    BOOL running;
}

+ (PLKLocationManager *)shared
{
    static PLKLocationManager *cache = nil;
    static dispatch_once_t onceTokenCache;
    dispatch_once(&onceTokenCache, ^{ cache = [[PLKLocationManager alloc] init]; });
    return cache;
}

- (void)setup
{
    running = NO;
    if([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted )
        {
            NSLog(@"Determining your current location cannot be performed at this time because location services are enabled but restricted");
        }
        else
        {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        }
        
        
    } else {
        NSLog(@"Location sharing set OFF!");
        
    }
}

- (void)start
{
    if(self.locationManager && !running) {
        running = YES;
        [self.locationManager startUpdatingLocation];
    }
    
}

- (void)stop
{
    if(self.locationManager && running) {
        running = NO;
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if(self.delegate)
        [self.delegate locationUpdate:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(locationError:)])
        [self.delegate locationError:error];
}

@end
