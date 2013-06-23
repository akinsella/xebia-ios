//
// Created by akinsella on 28/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBWordpressArrayDataSource.h"
#import "XBReloadableArrayDataSource+protected.h"
#import "XBHttpJsonDataLoader.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "XBJsonToArrayDataMapper.h"
#import "XBHttpClient.h"
#import "XBInfiniteScrollArrayDataSource+protected.h"
#import "WPDataPager.h"

@interface XBWordpressArrayDataSource()

@end

@implementation XBWordpressArrayDataSource

+ (id)dataSourceWithResourcePath:(NSString *)resourcePath rootKeyPath:(NSString *)rootKeyPath classType:(Class)classType httpClient:(XBHttpClient *)httpClient {
    return [[self alloc] initWithResourcePath:resourcePath rootKeyPath:rootKeyPath classType:classType httpClient:httpClient];
}

- (id)initWithResourcePath:(NSString *)resourcePath rootKeyPath:(NSString *)rootKeyPath classType:(Class)classType httpClient:(XBHttpClient *)httpClient {
    self = [super init];
    if (self) {
        self.dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient
                                                   httpQueryParamBuilder:[XBBasicHttpQueryParamBuilder builderWithDictionary:@{}]
                                                            resourcePath:resourcePath];

        self.dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:rootKeyPath typeClass:classType];

        self.dataPager = [WPDataPager dataPagerWithDataSource:self];
    }

    return self;
}

@end