//
// Created by akinsella on 10/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#import "LCHttpClient.h"
#import "XBHttpArrayDataSourceConfiguration.h"
#import "XBHttpArrayDataSource.h"

@interface XBHttpArrayDataSource (LCArrayDataSource_protected)

- (void)loadArrayFromJson:(NSDictionary *)json;

@end