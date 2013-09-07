//
// Created by akinsella on 19/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import "XBReloadableArrayDataSource.h"
#import "WPAuthor.h"
#import "XBBundleJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import <SenTestingKitAsync/SenTestingKitAsync.h>

#define kNetworkTimeout 30.0f

@interface XBBundleArrayDataSourceTest : SenTestCase @end

@implementation XBBundleArrayDataSourceTest

- (void)testLoadDataSourceFromBundle {

    XBBundleJsonDataLoader *dataLoader = [XBBundleJsonDataLoader dataLoaderWithResourcePath:@"wp-author-index" resourceType:@"json"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:@"authors" typeClass:[WPAuthor class]];
    XBReloadableArrayDataSource *bundleDS = [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];

    [bundleDS loadDataWithCallback:^() {
        STSuccess();
    }];

    // Wait for the async activity to complete
    STFailAfter(kNetworkTimeout, @"Expected response before timeout");
//    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kNetworkTimeout];

    STAssertNil(bundleDS.error, [NSString stringWithFormat:@"Error[code: '%ld', domain: '%@'", (long)bundleDS.error.code, bundleDS.error.domain]);
    STAssertTrue(bundleDS.count > 0, @"item count should be greater than 0");
}

@end