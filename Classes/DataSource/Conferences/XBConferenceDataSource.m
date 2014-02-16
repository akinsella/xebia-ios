//
// Created by Simone Civetta on 16/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceDataSource.h"
#import "XBJsonToArrayDataMapper.h"
#import "XBConference.h"
#import "XBHttpJsonDataLoader.h"
#import "XBReloadableArrayDataSource+protected.h"
#import "XBPListConfigurationProvider.h"
#import "XBBasicHttpQueryParamBuilder.h"


@implementation XBConferenceDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
        XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
        self.dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/conferences"];
        self.dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[XBConference class]];
    }

    return self;
}

+ (instancetype)dataSource {
    return [[self alloc] init];
}

@end