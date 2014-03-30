//
// Created by Simone Civetta on 30/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceBeaconDataSource.h"
#import "XBHttpClient.h"
#import "XBHttpJsonDataLoader.h"
#import "XBConferenceRatingHttpQueryParamBuilder.h"
#import "XBJsonToArrayDataMapper.h"
#import "XBReloadableArrayDataSource+protected.h"
#import "XBConferenceBeacon.h"


@implementation XBConferenceBeaconDataSource

+ (id)dataSourceWithHttpClient:(XBHttpClient *)httpClient {
    return [[self alloc] initWithHttpClient:httpClient];
}

- (id)initWithHttpClient:(XBHttpClient *)httpClient {
    self = [super init];
    if (self) {
        self.dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient
                                                   httpQueryParamBuilder:[XBBasicHttpQueryParamBuilder builderWithDictionary:@{}]
                                                            resourcePath:@"beacons"];

        self.dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[XBConferenceBeacon class]];
    }

    return self;
}

@end