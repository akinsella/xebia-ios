//
// Created by Alexis Kinsella on 08/04/13.
// Copyright (c) 2013 Xebia IT Architets. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSDictionary+XBAdditions.h"
#import "NSDateFormatter+XBAdditions.h"

#import <SenTestingKit/SenTestingKit.h>

@interface NSDictionaryTest : SenTestCase @end

@implementation NSDictionaryTest

-(void)testShouldConvertDictionaryToJSONString {
    NSDateFormatter *outputFormatter = [NSDateFormatter initWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setSecond:35];
    [components setMinute:58];
    [components setHour:23];
    [components setDay:16];
    [components setMonth:8];
    [components setYear:2013];
    [components setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Paris"]];
    NSDate *date = [calendar dateFromComponents:components];

//    date = [NSDate dateWithTimeIntervalSince1970:[date timeIntervalSince1970]];
    NSDictionary * dict = @{
        @"key": @"value",
        @"subDict": @{
            @"date": date
        }
    };

    NSError *error;
    NSString *json = [dict JSONStringWithError:&error dateFormatter:outputFormatter];
    NSLog(@"JSON: %@", json);
    STAssertEqualObjects(json, @"{\"key\":\"value\",\"subDict\":{\"date\":\"2013-08-16T23:58:35.000+0200\"}}", nil);
}

@end
