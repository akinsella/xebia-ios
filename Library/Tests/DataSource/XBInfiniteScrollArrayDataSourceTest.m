//
// Created by akinsella on 01/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBInfiniteScrollArrayDataSource.h"
#import <SenTestingKit/SenTestingKit.h>
#import "XBTestUtils.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "XBArrayDataSource+protected.h"
#import "XBDictionaryDataMerger.h"
#import "XBArrayDataSourceDataPager.h"
#import "XBDataPagerHttpQueryDataBuilder.h"

#import <SenTestingKitAsync/SenTestingKitAsync.h>

#define kNetworkTimeout 30.0f

@interface XBInfiniteScrollArrayDataSourceTest : SenTestCase @end

@implementation XBInfiniteScrollArrayDataSourceTest

-(void)testInfiniteScroll {

    id httpClient = [XBTestUtils fakeHttpClientWithSuccessiveSuccessCallbackWithData:@[
            [XBTestUtils getAuthorsAsJsonWithPage:1],
            [XBTestUtils getAuthorsAsJsonWithPage:2],
            [XBTestUtils getAuthorsAsJsonWithPage:3]
    ] parameterName:@"page"];


    XBArrayDataSourceDataPager *dataPager = [XBArrayDataSourceDataPager paginatorWithItemByPage:25];
    XBDataPagerHttpQueryDataBuilder *httpQueryDataBuilder = [XBDataPagerHttpQueryDataBuilder builderWithDataPager:dataPager pageParameterName:@"page"];

    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient
                                                                    httpQueryParamBuilder:httpQueryDataBuilder
                                                                         resourcePath:@"/wp-json-api/get_author_index/"];

    XBJsonToArrayDataMapper * dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:@"authors" typeClass:[WPAuthor class]];

    XBDictionaryDataMerger * dataMerger = [XBDictionaryDataMerger dataMergerWithRootKeyPath: @"authors"];

    XBInfiniteScrollArrayDataSource *dataSource = [XBInfiniteScrollArrayDataSource dataSourceWithDataLoader:dataLoader
                                                                                                 dataMapper:dataMapper
                                                                                                 dataMerger:dataMerger
                                                                                                  dataPager:dataPager];

    dataPager.dataSource = dataSource;

    [dataSource loadDataWithCallback:^() {
        STAssertTrue([dataSource hasMoreData], nil);

        [dataSource loadMoreDataWithCallback:^{
            STSuccess();
        }];
    }];

    STFailAfter(kNetworkTimeout, @"Expected response before timeout");

    STAssertNil(dataSource.error, [NSString stringWithFormat:@"Error[code: '%ld', domain: '%@'", (long) dataSource.error.code, dataSource.error.domain]);
    STAssertEquals(dataSource.count, 60U, nil);

    WPAuthor *author = [XBTestUtils findAuthorInArray:dataSource.array ById:50];

    STAssertEquals([author.identifier unsignedIntegerValue], 50U, nil);
    STAssertEqualObjects(author.slug, @"akinsella", nil);
    STAssertEqualObjects(author.name, @"Alexis Kinsella", nil);
    STAssertEqualObjects(author.firstName, @"Alexis", nil);
    STAssertEqualObjects(author.lastName, @"Kinsella", nil);
    STAssertEqualObjects(author.nickname, @"akinsella", nil);
    STAssertEqualObjects(author.url, @"http://www.xebia.fr", nil);
    STAssertEqualObjects(author.description_, @"", nil);
}

@end