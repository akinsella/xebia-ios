//
// Created by akinsella on 26/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBHttpArrayDataSource.h"
#import "XBPagedArrayDataSource.h"
#import "XBPagedHttpQueryParamBuilder.h"

@interface XBPagedHttpArrayDataSource : XBHttpArrayDataSource<XBPagedArrayDataSource>

@property (nonatomic, assign, readonly)NSObject<XBPagedHttpQueryParamBuilder> * httpPagedQueryParamBuilder;

+ (id)dataSourceWithConfiguration:(XBHttpArrayDataSourceConfiguration *)configuration httpClient:(XBHttpClient *)httpClient;

- (id)initWithConfiguration:(XBHttpArrayDataSourceConfiguration *)configuration httpClient:(XBHttpClient *)httpClient;

@end