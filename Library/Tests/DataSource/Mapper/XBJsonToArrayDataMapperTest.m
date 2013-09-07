//
// Created by akinsella on 01/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBJsonToArrayDataMapper.h"
#import <SenTestingKit/SenTestingKit.h>
#import "WPAuthor.h"
#import "XBTestUtils.h"

@interface XBJsonToArrayDataMapperTest : SenTestCase @end

@implementation XBJsonToArrayDataMapperTest

- (void)testCount {
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:@"authors" typeClass:[WPAuthor class]];
    NSArray *wpAuthors = [dataMapper mapData:[XBTestUtils getAuthorsAsJson]];

    STAssertEquals(wpAuthors.count, 70U, nil);
}

- (void)testValues {
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:@"authors" typeClass:[WPAuthor class]];
    NSArray *authors = [dataMapper mapData:[XBTestUtils getAuthorsAsJson]];

    WPAuthor *wpAuthor = [XBTestUtils findAuthorInArray:authors ById:50];

    STAssertEquals([wpAuthor.identifier unsignedIntegerValue], 50U, nil);
    STAssertEqualObjects(wpAuthor.slug, @"akinsella", nil);
    STAssertEqualObjects(wpAuthor.name, @"Alexis Kinsella", nil);
    STAssertEqualObjects(wpAuthor.firstname, @"Alexis", nil);
    STAssertEqualObjects(wpAuthor.lastname, @"Kinsella", nil);
    STAssertEqualObjects(wpAuthor.nickname, @"akinsella", nil);
    STAssertEqualObjects(wpAuthor.url, @"http://www.xebia.fr", nil);
    STAssertEqualObjects(wpAuthor.description_, @"", nil);
}

@end