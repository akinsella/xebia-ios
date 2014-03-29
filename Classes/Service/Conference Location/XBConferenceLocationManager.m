//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceLocationManager.h"

@interface XBConferenceLocationManager ()

@property (nonatomic, strong) CLLocationManager     *locationManager;
@property (nonatomic, assign) BOOL                  didShowEntranceNotifier;
@property (nonatomic, assign) BOOL                  didShowExitNotifier;

@property (nonatomic, strong) CLBeaconRegion        *beaconRegion;

@end

@implementation XBConferenceLocationManager

- (void)startBeaconRanging {

    // set entrance notifier flag
    self.didShowEntranceNotifier = YES;

    // start beacon ranging
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];

    // fire notification with region update
    [self fireUpdateNotificationForStatus:@"Welcome!  You have entered the target region."];
}

- (CLBeaconRegion *)beaconRegion
{
    if (!_beaconRegion) {
        NSUUID *uuid = [[NSUUID alloc] init];
        _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:XBConferenceLocationIdentifier];
        _beaconRegion.notifyEntryStateOnDisplay = YES;
        _beaconRegion.notifyOnEntry = YES;
        _beaconRegion.notifyOnExit = YES;
    }

    return _beaconRegion;
}

- (void)fireUpdateNotificationForStatus:(NSString*)status {
    // fire notification to update displayed status
    [[NSNotificationCenter defaultCenter] postNotificationName:XBConferenceLocationUpdateNotification
                                                        object:nil
                                                      userInfo:@{@"status" : status}];
}

#pragma mark - CLLocationManager Helpers

- (void)initializeRegionMonitoring {

    // initialize new location manager
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }

    // begin region monitoring
    [self.locationManager startMonitoringForRegion:self.beaconRegion];

    // fire notification with initial status
    [self fireUpdateNotificationForStatus:@"Initializing CLLocationManager and initiating region monitoring..."];
}

- (void)stopMonitoringForRegion:(CLBeaconRegion*)region {
    // stop monitoring for region
    [self.locationManager stopMonitoringForRegion:region];

    self.locationManager = nil;

    // reset notifiers
    self.didShowEntranceNotifier = NO;
    self.didShowExitNotifier = NO;
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

    // fire notification with failure status
    [self fireUpdateNotificationForStatus:[NSString stringWithFormat:@"Location manager failed with error: %@",error.localizedDescription]];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {

    // handle notifyEntryStateOnDisplay
    // notify user they have entered the region, if you haven't already
    if (manager == self.locationManager &&
            [region.identifier isEqualToString:XBConferenceLocationIdentifier] &&
            state == CLRegionStateInside &&
            !self.didShowEntranceNotifier) {

        // start beacon ranging
        [self startBeaconRanging];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {

    // handle notifyOnEntry
    // notify user they have entered the region, if you haven't already
    if (manager == self.locationManager &&
            [region.identifier isEqualToString:XBConferenceLocationIdentifier] &&
            !self.didShowEntranceNotifier) {

        // start beacon ranging
        [self startBeaconRanging];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {

    // optionally notify user they have left the region
    if (!self.didShowExitNotifier) {

        self.didShowExitNotifier = YES;

        // fire notification with region update
        [self fireUpdateNotificationForStatus:@"Thanks for visiting.  You have now left the target region."];
    }

    // reset entrance notifier
    self.didShowEntranceNotifier = NO;

    // stop beacon ranging
    [manager stopRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {

    // identify closest beacon in range
    if ([beacons count] > 0) {
        CLBeacon *closestBeacon = beacons[0];
        if (closestBeacon.proximity == CLProximityImmediate) {
            /**
             Provide proximity based information to user.  You may choose to do this repeatedly
             or only once depending on the use case.  Optionally use major, minor values here to provide beacon-specific content
             */
            [self fireUpdateNotificationForStatus:@"You are in the immediate vicinity of the Beacon."];

        } else if (closestBeacon.proximity == CLProximityNear) {
            // detect other nearby beacons
            // optionally hide previously displayed proximity based information
            [self fireUpdateNotificationForStatus:@"There are Beacons nearby."];
        }
    } else {
        // no beacons in range - signal may have been lost
        // optionally hide previously displayed proximity based information
        [self fireUpdateNotificationForStatus:@"There are currently no Beacons within range."];
    }
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {

    // fire notification of range failure
    [self fireUpdateNotificationForStatus:[NSString stringWithFormat:@"Beacon ranging failed with error: %@", error]];

    // assume notifications failed, reset indicators
    self.didShowEntranceNotifier = NO;
    self.didShowExitNotifier = NO;
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {

    // fire notification of region monitoring
    [self fireUpdateNotificationForStatus:[NSString stringWithFormat:@"Now monitoring for region: %@",((CLBeaconRegion*)region).identifier]];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {

    // fire notification with status update
    [self fireUpdateNotificationForStatus:[NSString stringWithFormat:@"Region monitoring failed with error: %@", error]];

    // assume notifications failed, reset indicators
    self.didShowEntranceNotifier = NO;
    self.didShowExitNotifier = NO;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

    // current location usage is required to use this demo app
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        [[[UIAlertView alloc] initWithTitle:@"Current Location Required"
                                    message:@"Please re-enable Core Location to run this Demo.  The app will now exit."
                                   delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

}

@end