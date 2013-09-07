//
// Created by Alexis Kinsella on 08/04/13.
// Copyright (c) 2013 Xebia IT Architets. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import "NSIndexSet+XBAdditions.h"

@interface NSIndexSetTest : SenTestCase
@end

@implementation NSIndexSetTest

-(void)testShouldConvertIndexSetToString {
    NSMutableIndexSet * indexSet = [NSMutableIndexSet indexSet];
    [indexSet addIndex:23];
    [indexSet addIndex:34];
    [indexSet addIndex:45];

    NSString *result = [indexSet joinByString:@","];

    STAssertEqualObjects(result, @"23,34,45", nil);
}

-(void)testShouldConvertIndexSetWithOneValueToString {
    NSMutableIndexSet * indexSet = [NSMutableIndexSet indexSetWithIndex:23];

    NSString *result = [indexSet joinByString:@","];

    STAssertEqualObjects(result, @"23", nil);
}

@end