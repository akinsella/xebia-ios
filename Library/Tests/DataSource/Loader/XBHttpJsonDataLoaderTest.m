//
// Created by akinsella on 01/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "XBHttpJsonDataLoader.h"
#import <SenTestingKit/SenTestingKit.h>
#import "XBTestUtils.h"
#import <SenTestingKitAsync/SenTestingKitAsync.h>

#define kNetworkTimeout 30.0f

@interface XBHttpJsonDataLoaderTest : SenTestCase @end

@implementation XBHttpJsonDataLoaderTest

- (void)testFetchDataResult {
    id httpClient = [XBTestUtils fakeHttpClientWithSuccessCallbackWithData:[XBTestUtils getAuthorsAsJson]];

    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient
                                                                         resourcePath:@"/wp-json-api/get_author_index/"];

    __block NSDictionary *responseData;
    __block NSError *responseError;

    [dataLoader loadDataWithSuccess:^(NSDictionary * data) {
        responseData = data;
        STSuccess();
    } failure:^(NSError *error) {
        responseError = error;
        STSuccess();
    }];

    STFailAfter(kNetworkTimeout, @"Expected response before timeout");

    STAssertNil(responseError, [NSString stringWithFormat:@"Error[code: '%ld', domain: '%@'", (long)responseError.code, responseError.domain]);

    NSString *status = responseData[@"status"];
    NSNumber *count = responseData[@"count"];
    NSArray *authors = responseData[@"authors"];

    STAssertEqualObjects(status, @"ok", nil);
    STAssertEquals([count unsignedIntegerValue], 70U, nil);
    STAssertEquals(authors.count, 70U, nil);
}

@end