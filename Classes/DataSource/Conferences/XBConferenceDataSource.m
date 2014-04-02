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
#import "XBFileSystemCacheSupport.h"
#import "XBCache.h"
#import "XBHttpDataLoaderCacheKeyBuilder.h"
#import "XBCacheableDataLoader.h"
#import "XBArrayDataSource+protected.h"


@implementation XBConferenceDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];

        XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
        XBHttpJsonDataLoader *httpJsonDataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/conferences"];

        XBFileSystemCacheSupport * cacheSupport = [XBFileSystemCacheSupport cacheSupportWithFilename:@"conference-list-cache"];

        XBCache *cache = [XBCache cacheWithCacheSupport:cacheSupport];
        XBHttpDataLoaderCacheKeyBuilder *cacheKeyBuilder = [XBHttpDataLoaderCacheKeyBuilder cacheKeyBuilder];

        self.dataLoader = [XBCacheableDataLoader dataLoaderWithDataLoader:httpJsonDataLoader
                                                                    cache:cache
                                                          cacheKeyBuilder:cacheKeyBuilder
                                                                      ttl:300];
        self.dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[XBConference class]];

        [self setFilterPredicate:^BOOL(XBConference *conference) {
            return [conference.enabled boolValue];
        }];
    }

    return self;
}

+ (instancetype)dataSource {
    return [[self alloc] init];
}

@end