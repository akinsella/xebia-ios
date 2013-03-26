//
// Created by akinsella on 26/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#import "XBHttpQueryParamBuilder.h"

@protocol XBPagedHttpQueryParamBuilder<XBHttpQueryParamBuilder>

@required

- (NSUInteger)currentPage;

- (NSUInteger)itemByPage;

- (void)incrementPage;

- (Boolean)hasMorePages;

- (void)resetPageIncrement;

@end