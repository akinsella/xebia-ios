//
// Created by akinsella on 19/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <SenTestingKit/SenTestingKit.h>
#import "XBInfiniteScrollArrayDataSource.h"
#import "WPAuthor.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "JSONKit.h"
#import "XBTestUtils.h"
#import "Underscore.h"
#import "XBArrayDataSource+protected.h"
#import <SenTestingKitAsync/SenTestingKitAsync.h>

#define kNetworkTimeout 30.0f

@interface XBHttpArrayDataSourceTest : SenTestCase @end

@implementation XBHttpArrayDataSourceTest

- (void)testFetchDataResult {

    id httpClient = [XBTestUtils fakeHttpClientWithSuccessCallbackWithData:[XBTestUtils getAuthorsAsJson]];

    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient
                                                                         resourcePath:@"/wp-json-api/get_author_index/"];

    XBJsonToArrayDataMapper * dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:@"authors" typeClass:[WPAuthor class]];

    XBReloadableArrayDataSource *dataSource = [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader
                                                                                         dataMapper:dataMapper];

    [dataSource loadDataWithCallback:^() {
        STSuccess();
    }];

    STFailAfter(kNetworkTimeout, @"Expected response before timeout");

    STAssertNil(dataSource.error, [NSString stringWithFormat:@"Error[code: '%ld', domain: '%@'", (long) dataSource.error.code, dataSource.error.domain]);
    STAssertEquals(dataSource.count, 70U, nil);

    WPAuthor *author = [XBTestUtils findAuthorInArray:dataSource.array ById:50];

    STAssertEquals([author.identifier unsignedIntegerValue], 50U, nil);
    STAssertEqualObjects(author.slug, @"akinsella", nil);
    STAssertEqualObjects(author.name, @"Alexis Kinsella", nil);
    STAssertEqualObjects(author.firstname, @"Alexis", nil);
    STAssertEqualObjects(author.lastname, @"Kinsella", nil);
    STAssertEqualObjects(author.nickname, @"akinsella", nil);
    STAssertEqualObjects(author.url, @"http://www.xebia.fr", nil);
    STAssertEqualObjects(author.description_, @"", nil);
}

@end