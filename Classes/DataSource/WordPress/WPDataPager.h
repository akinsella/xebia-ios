//
// Created by akinsella on 28/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBDataPager.h"
#import "XBWordpressArrayDataSource.h"

@interface WPDataPager : NSObject<XBDataPager>

@property(nonatomic, weak, readonly) XBWordpressArrayDataSource *dataSource;

- (id)initWithDataSource:(XBWordpressArrayDataSource *)dataSource;

+ (id)dataPagerWithDataSource:(XBWordpressArrayDataSource *)dataSource;

@end