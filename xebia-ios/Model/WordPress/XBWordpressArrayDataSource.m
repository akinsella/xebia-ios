//
// Created by akinsella on 28/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBWordpressArrayDataSource.h"
#import "XBWordpressPaginator.h"


@implementation XBWordpressArrayDataSource

+(id)dataSourceWithConfiguration:(XBHttpArrayDataSourceConfiguration *)configuration
                      httpClient:(XBHttpClient *)httpClient {
    return [[self alloc] initWithConfiguration:configuration httpClient:httpClient];
}

- (id)initWithConfiguration:(XBHttpArrayDataSourceConfiguration *)configuration
                 httpClient:(XBHttpClient *)httpClient {
    self = [super initWithConfiguration:configuration httpClient:httpClient];
    if (self) {
        _paginator = [XBWordpressPaginator paginatorWithDataSource:self];
    }

    return self;
}

- (NSArray *)data {
    NSDictionary *rawData = [self rawData];
    return rawData[@"data"];
}

- (NSDictionary *)mergeJsonFetched:(id)jsonFetched {
    NSDictionary *json;
    NSMutableArray * mergedArray = [[self data] mutableCopy];

    [mergedArray addObjectsFromArray: (_rootKeyPath ? [jsonFetched valueForKeyPath:_rootKeyPath][@"data"] : jsonFetched[@"data"])];

    json = @{
            @"lastUpdate": [_dateFormat stringFromDate:[NSDate date]],
            @"data": @{
                    @"pages":jsonFetched[@"pages"],
                    @"count":jsonFetched[@"count"],
                    @"total":jsonFetched[@"total"],
                    @"data": mergedArray
            }
    };

    return json;

}

@end