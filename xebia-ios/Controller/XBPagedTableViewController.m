//
//  XBTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "GHRepositoryTableViewController.h"
#import "UIColor+XBAdditions.h"
#import "SVPullToRefresh.h"
#import "SVProgressHUD.h"
#import "UITableViewCell+VariableHeight.h"
#import "UIViewController+XBAdditions.h"
#import "XBConfigurationProvider.h"
#import "XBPagedTableViewController.h"
#import "XBPagedArrayDataSource.h"
#import "XBPagedHttpArrayDataSource.h"

@implementation XBPagedTableViewController

-(void)initialize {
    _dataSource = [XBPagedHttpArrayDataSource dataSourceWithConfiguration:[self.delegate configuration]
                                                          httpClient:self.appDelegate.configurationProvider.httpClient];
}

-(NSObject<XBPagedArrayDataSource> *)pagedDataSource {
    return (NSObject<XBPagedArrayDataSource> *)self.dataSource;
}


-(void)loadNextPageWithCallback:(void(^)())callback {
    [SVProgressHUD showWithStatus:@"Fetching data" maskType:SVProgressHUDMaskTypeBlack];
    [self.pagedDataSource loadNextPageWithCallback:^(){
         if (self.dataSource.error) {
             [SVProgressHUD showErrorWithStatus:@"Got some issue!"];
         }
         else {
             [SVProgressHUD showSuccessWithStatus:@"Done!"];
         }

         if (callback) {
             callback();
         }
    }];

}

@end