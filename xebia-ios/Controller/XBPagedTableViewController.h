//
// Created by akinsella on 19/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBHttpArrayDataSource.h"
#import "XBHttpArrayDataSourceConfiguration.h"
#import "XBHttpClient.h"
#import "XBConfigurationProvider.h"
#import "XBTableViewController.h"
#import "XBPagedArrayDataSource.h"

@interface XBPagedTableViewController : XBTableViewController

@property(nonatomic, strong, readonly)NSObject<XBPagedArrayDataSource> *pagedDataSource;

-(void)loadNextPageWithCallback:(void(^)())callback;

@end
