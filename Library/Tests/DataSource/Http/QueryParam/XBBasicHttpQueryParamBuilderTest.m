//
// Created by akinsella on 01/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBBasicHttpQueryParamBuilder.h"
#import <SenTestingKit/SenTestingKit.h>

@interface XBBasicHttpQueryParamBuilderTest : SenTestCase @end

@implementation XBBasicHttpQueryParamBuilderTest

-(void)testBuild {
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{
        @"count": @20,
        @"page": @10,
        @"slug":@"ios"
    }];

    NSDictionary *dictionary = [httpQueryParamBuilder build];

    STAssertEqualObjects(dictionary[@"slug"], @"ios", nil);
    STAssertEquals([dictionary[@"count"] unsignedIntegerValue], 20U, nil);
    STAssertEquals([dictionary[@"page"] unsignedIntegerValue], 10U, nil);
}

@end