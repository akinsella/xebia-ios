//
// Created by akinsella on 19/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import "XBInfiniteScrollArrayDataSource.h"
#import "WPAuthor.h"
#import "XBHttpClient.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"


@interface XBArrayDataSourceTest : SenTestCase @end

@implementation XBArrayDataSourceTest

XBPredicateBlock itemFilterPredicate = ^BOOL(NSString* item) {
    return [item rangeOfString:@"item"].location != NSNotFound;
};

XBPredicateBlock testFilterPredicate = ^BOOL(NSString* item) {
    return [item rangeOfString:@"test"].location != NSNotFound;
};

NSComparator stringComparator = ^NSComparisonResult(NSString *str1, NSString *str2) {
    return [str1 caseInsensitiveCompare:str2];
};

NSComparator reverseStringComparator = ^NSComparisonResult(NSString *str1, NSString *str2) {
    return -[str1 caseInsensitiveCompare:str2];
};

- (void)testCount {

    NSArray *array = @[@"item1", @"item2", @"item3"];

    XBArrayDataSource *dataSource = [XBArrayDataSource dataSourceWithArray:array];
    STAssertEquals(dataSource.count, 3U, nil);
}

- (void)testObjectSubScripting {

    NSArray *array = @[@"item1", @"item2", @"item3"];

    XBArrayDataSource *dataSource = [XBArrayDataSource dataSourceWithArray:array];
    STAssertEqualObjects(dataSource[0], @"item1", nil);
    STAssertEqualObjects(dataSource[1], @"item2", nil);
    STAssertEqualObjects(dataSource[2], @"item3", nil);
}

- (void)testFilter {

    NSArray *array = @[@"item1", @"item2", @"test1", @"item3", @"test2"];

    XBArrayDataSource *dataSource = [XBArrayDataSource dataSourceWithArray:array];
    [dataSource filter:itemFilterPredicate];
    STAssertEquals(dataSource.count, 3U, nil);
    STAssertEqualObjects(dataSource[0], @"item1", nil);
    STAssertEqualObjects(dataSource[1], @"item2", nil);
    STAssertEqualObjects(dataSource[2], @"item3", nil);
}

- (void)testSort {

    NSArray *array = @[@"item1", @"item3", @"test2", @"item2", @"test1"];

    XBArrayDataSource *dataSource = [XBArrayDataSource dataSourceWithArray:array];
    [dataSource sort:stringComparator];
    STAssertEquals(dataSource.count, 5U, nil);
    STAssertEqualObjects(dataSource[0], @"item1", nil);
    STAssertEqualObjects(dataSource[1], @"item2", nil);
    STAssertEqualObjects(dataSource[2], @"item3", nil);
    STAssertEqualObjects(dataSource[3], @"test1", nil);
    STAssertEqualObjects(dataSource[4], @"test2", nil);
}

- (void)testFilterAndSort {
    NSArray *array = @[@"item2", @"test3", @"test2", @"item1", @"test1"];

    XBArrayDataSource *dataSource = [XBArrayDataSource dataSourceWithArray:array];
    [dataSource filter:itemFilterPredicate];

    STAssertEquals(dataSource.count, 2U, nil);
    STAssertEqualObjects(dataSource[0], @"item2", nil);
    STAssertEqualObjects(dataSource[1], @"item1", nil);

    [dataSource sort:stringComparator];

    STAssertEquals(dataSource.count, 2U, nil);
    STAssertEqualObjects(dataSource[0], @"item1", nil);
    STAssertEqualObjects(dataSource[1], @"item2", nil);
}

- (void)testFilterTwoTimes {
    NSArray *array = @[@"item2", @"item3", @"test2", @"item1", @"test1"];

    XBArrayDataSource *dataSource = [XBArrayDataSource dataSourceWithArray:array];
    [dataSource filter:itemFilterPredicate];

    STAssertEquals(dataSource.count, 3U, nil);
    STAssertEqualObjects(dataSource[0], @"item2", nil);
    STAssertEqualObjects(dataSource[1], @"item3", nil);
    STAssertEqualObjects(dataSource[2], @"item1", nil);

    [dataSource filter:testFilterPredicate];

    STAssertEquals(dataSource.count, 2U, nil);
    STAssertEqualObjects(dataSource[0], @"test2", nil);
    STAssertEqualObjects(dataSource[1], @"test1", nil);
}


- (void)testSortTwoTimes {
    NSArray *array = @[@"item2", @"item3", @"test2", @"item1", @"test1"];

    XBArrayDataSource *dataSource = [XBArrayDataSource dataSourceWithArray:array];
    [dataSource sort:stringComparator];

    STAssertEquals(dataSource.count, 5U, nil);
    STAssertEqualObjects(dataSource[0], @"item1", nil);
    STAssertEqualObjects(dataSource[1], @"item2", nil);
    STAssertEqualObjects(dataSource[2], @"item3", nil);
    STAssertEqualObjects(dataSource[3], @"test1", nil);
    STAssertEqualObjects(dataSource[4], @"test2", nil);

    [dataSource sort:reverseStringComparator];

    STAssertEquals(dataSource.count, 5U, nil);
    STAssertEqualObjects(dataSource[0], @"test2", nil);
    STAssertEqualObjects(dataSource[1], @"test1", nil);
    STAssertEqualObjects(dataSource[2], @"item3", nil);
    STAssertEqualObjects(dataSource[3], @"item2", nil);
    STAssertEqualObjects(dataSource[4], @"item1", nil);

}

- (void)testFilterSortOnConstruct {
    NSArray *array = @[@"item2", @"test3", @"test2", @"item1", @"test1"];

    XBArrayDataSource *dataSource = [XBArrayDataSource dataSourceWithArray:array
                                                           filterPredicate:itemFilterPredicate
                                                            sortComparator:stringComparator];

    STAssertEquals(dataSource.count, 2U, nil);
    STAssertEqualObjects(dataSource[0], @"item1", nil);
    STAssertEqualObjects(dataSource[1], @"item2", nil);
}

@end