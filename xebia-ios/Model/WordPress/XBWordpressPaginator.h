//
// Created by akinsella on 28/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBPaginator.h"
#import "XBWordpressArrayDataSource.h"

@interface XBWordpressPaginator : NSObject<XBPaginator>

@property(nonatomic, weak, readonly) XBWordpressArrayDataSource *dataSource;

- (id)initWithDataSource:(XBWordpressArrayDataSource *)dataSource;

+ (id)paginatorWithDataSource:(XBWordpressArrayDataSource *)dataSource;


@end