//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *XBConferenceLocationUpdateNotification = @"XBConferenceLocationUpdateNotification";
static NSString *XBConferenceLocationIdentifier = @"XBConferenceLocationIdentifier";

@interface XBConferenceLocationManager : NSObject <CLLocationManagerDelegate>

- (void)initializeRegionMonitoring;
- (void)stopMonitoringForRegion:(CLBeaconRegion *)region;

@end