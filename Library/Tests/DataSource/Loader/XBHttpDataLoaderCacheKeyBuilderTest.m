//
// Created by akinsella on 01/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import "XBTestUtils.h"
#import "XBHttpJsonDataLoader.h"
#import "XBHttpDataLoaderCacheKeyBuilder.h"
#import "XBBasicHttpQueryParamBuilder.h"

@interface XBHttpDataLoaderCacheKeyBuilderTest : SenTestCase @end

@implementation XBHttpDataLoaderCacheKeyBuilderTest

-(void)testWithoutQueryParam {

    id httpClient = [XBTestUtils fakeHttpClientWithSuccessCallbackWithData:[XBTestUtils getAuthorsAsJson]];

    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient
                                                                         resourcePath:@"/wp-json-api/get_author_index/"];


    XBHttpDataLoaderCacheKeyBuilder *cacheKeyBuilder = [XBHttpDataLoaderCacheKeyBuilder cacheKeyBuilder];

    NSString *result = [cacheKeyBuilder buildWithData:dataLoader];

    STAssertEqualObjects(result, @"http://blog.xebia.fr/wp-json-api/get_author_index/", nil);
}

-(void)testWithQueryParams {

    id httpClient = [XBTestUtils fakeHttpClientWithSuccessCallbackWithData:[XBTestUtils getAuthorsAsJson]];

    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{
        @"count": @20,
        @"page": @10,
        @"slug":@"ios"
    }];

    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient
                                                                httpQueryParamBuilder: httpQueryParamBuilder
                                                                         resourcePath:@"/wp-json-api/get_author_index/"];


    XBHttpDataLoaderCacheKeyBuilder *cacheKeyBuilder = [XBHttpDataLoaderCacheKeyBuilder cacheKeyBuilder];

    NSString *result = [cacheKeyBuilder buildWithData:dataLoader];

    STAssertEqualObjects(result, @"http://blog.xebia.fr/wp-json-api/get_author_index/?count=20&page=10&slug=ios", nil);
}

@end