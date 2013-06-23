//
// Created by akinsella on 05/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "WPDataMerger.h"


@implementation WPDataMerger

- (id)mergeDataFromSource:(id)srcData toDest:(id)destData {

    NSArray *mergedArray = [super mergeDataFromSource:srcData[@"data"] toDest:destData[@"data"]];

    NSDictionary * json = @{
        @"pages":destData[@"pages"],
        @"count":destData[@"count"],
        @"total":destData[@"total"],
        @"data": mergedArray
    };

    return json;
}

@end