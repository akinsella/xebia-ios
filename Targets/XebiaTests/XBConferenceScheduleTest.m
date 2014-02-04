//
// Created by Simone Civetta on 04/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <SenTestingKitAsync/SenTestingKitAsync.h>
#import "XBArrayDataSource.h"
#import "XBConferenceScheduleDataSource.h"
#import "XBConferencePresentation.h"
#import "NSDate+XBAdditions.h"

#define kNetworkTimeout 30.0f

@interface XBConferenceScheduleTest : SenTestCase @end

@implementation XBConferenceScheduleTest

- (void)testScheduleDeserialization {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"schedule" ofType:@"json"];
    XBConferenceScheduleDataSource *dataSource = [XBConferenceScheduleDataSource dataSourceWithResourcePath:path];
    [dataSource loadDataWithCallback:^{
        STSuccess();
    }];

    STFailAfter(kNetworkTimeout, @"Expected response before timeout");

    STAssertTrue(dataSource.error == nil, nil);
    XBConferencePresentation *pres = dataSource[0];
    STAssertTrue([pres isKindOfClass:[XBConferencePresentation class]], nil);
    STAssertTrue([[pres fromTime] day] == 11, nil);
    STAssertTrue([[pres fromTime] month] == 11, nil);
    STAssertTrue([[pres fromTime] hours] == 9, nil);
}

@end