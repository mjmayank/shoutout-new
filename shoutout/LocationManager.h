//
//  LocationManager.h
//  moment
//
//  Created by Mayank Jain on 9/24/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <Firebase/Firebase.h>

#define Notification_LocationUpdate @"LocationUpdate"

typedef enum {SOLocationStatusBackground, SOLocationStatusOff, SOLocationStatusForeground} SOLocationStatus;

@interface LocationManager : NSObject <CLLocationManagerDelegate>
@property(nonatomic, strong, readonly) CLLocation *lastLocation;
@property(nonatomic, assign) SOLocationStatus locationStatus;

+(id)initLocationManager;

#pragma mark -
#pragma mark Location Methods

-(void)enterBackgroundMode;
-(void)enterForegroundMode;
-(void)stopLocationUpdates;
+ (LocationManager *)sharedLocationManager;


@end
