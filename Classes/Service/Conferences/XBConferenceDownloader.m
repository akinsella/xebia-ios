//
// Created by Simone Civetta on 25/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceDownloader.h"
#import "XBConferenceRoomDataSource.h"
#import "XBArrayDataSource+protected.h"
#import "XBConference.h"

static NSString *const XBUserDefaultsBeaconKey = @"beacons";
static NSString *const XBConferenceDownloaderRootFolder = @"conferences";

@implementation XBConferenceDownloader

+ (NSString *)rootFolder {
    return XBConferenceDownloaderRootFolder;
}

- (void)downloadAllResources:(void (^)(NSError *))completionBlock {
    [super downloadAllResources:^(NSError *error) {
        if (completionBlock) {
            [self serializeRoomBeacons];
            completionBlock(error);
        }
    }];
}

- (void)serializeRoomBeacons {
    XBConference *conference = (XBConference *) self.downloadableBundle;
    if (!conference.identifier) {
        return;
    }
    NSString *roomPath = [self.bundleFolderPath stringByAppendingPathComponent:@"rooms"];
    XBConferenceRoomDataSource *roomDataSource = [XBConferenceRoomDataSource dataSourceWithResourcePath:roomPath];
    [roomDataSource loadDataWithCallback:^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *allBeacons = [NSMutableDictionary dictionaryWithDictionary:[userDefaults dictionaryForKey:XBUserDefaultsBeaconKey]];
        NSDictionary *dictionaryWithRoomsAndBeacons = [roomDataSource dictionaryWithRoomsAndBeacons];
        allBeacons[conference.identifier] = dictionaryWithRoomsAndBeacons;
        [userDefaults setObject:[NSDictionary dictionaryWithDictionary:allBeacons] forKey:XBUserDefaultsBeaconKey];
        [userDefaults synchronize];
        
    }];
}


@end