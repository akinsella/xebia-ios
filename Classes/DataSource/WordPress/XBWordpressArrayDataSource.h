//
// Created by akinsella on 28/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBInfiniteScrollArrayDataSource.h"
#import "XBHttpClient.h"


@interface XBWordpressArrayDataSource : XBInfiniteScrollArrayDataSource

+ (id)dataSourceWithResourcePath:(NSString *)resourcePath rootKeyPath:rootKeyPath classType:(Class)classType httpClient:(XBHttpClient *)httpClient;

- (id)initWithResourcePath:(NSString *)resourcePath rootKeyPath:rootKeyPath classType:(Class)classType httpClient:(XBHttpClient *)httpClient;

@end