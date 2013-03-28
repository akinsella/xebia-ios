//
// Created by akinsella on 28/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBWordpressPaginator.h"


@implementation XBWordpressPaginator {
    NSUInteger _currentPage;
}

+ (id)paginatorWithDataSource:(XBWordpressArrayDataSource *)dataSource {
    return [[self alloc] initWithDataSource:dataSource];
}

- (id)initWithDataSource:(XBWordpressArrayDataSource *)dataSource {
    self = [super init];
    if (self) {
        _currentPage = 1;
        _dataSource = dataSource;
    }

    return self;
}

- (NSDictionary *)rawData {
    return [_dataSource rawData];
}

- (NSUInteger)currentPage {
    NSDictionary *dictionary = [self rawData];
    if (!dictionary) {
        return 1;
    }
    NSString *page = (NSString *)dictionary[@"pages"];
    return (NSUInteger)[page integerValue];
}

- (NSUInteger)itemByPage {
    NSDictionary *dictionary = [self rawData];
    if (!dictionary) {
        return 25;
    }
    NSString *total = (NSString *)dictionary[@"count"];
    return (NSUInteger)[total integerValue];
}

- (NSUInteger)totalItem {
    NSDictionary *dictionary = [self rawData];
    if (!dictionary) {
        return 0;
    }
    NSString *total = (NSString *)dictionary[@"total"];
    return (NSUInteger)[total integerValue];
}

- (void)incrementPage {
    _currentPage++;
}

- (Boolean)hasMorePages {
    return [self totalItem] > _currentPage * ([self itemByPage] + 1);
}

- (void)resetPageIncrement {
    _currentPage = 1;
}

@end