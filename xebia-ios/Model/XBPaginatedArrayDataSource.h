//
// Created by akinsella on 10/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBArrayDataSource.h"


@interface XBPaginatedArrayDataSource : XBArrayDataSource

- (NSInteger)page;

- (NSInteger)count;

- (NSInteger)total;

@end