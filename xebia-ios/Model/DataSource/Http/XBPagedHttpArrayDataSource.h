//
// Created by akinsella on 26/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBHttpArrayDataSource.h"
#import "XBPagedArrayDataSource.h"

@interface XBPagedHttpArrayDataSource : XBHttpArrayDataSource<XBPagedArrayDataSource> {
    NSObject<XBPaginator> *_paginator;
}

+ (id)dataSourceWithConfiguration:(XBHttpArrayDataSourceConfiguration *)configuration httpClient:(XBHttpClient *)httpClient;

- (id)initWithConfiguration:(XBHttpArrayDataSourceConfiguration *)configuration httpClient:(XBHttpClient *)httpClient;

- (NSDictionary *)mergeJsonFetched:(id)jsonFetched;

@end