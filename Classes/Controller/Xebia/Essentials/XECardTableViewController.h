//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBReloadableTableViewController.h"
#import "XECategory.h"

@interface XECardTableViewController : XBReloadableTableViewController<UITableViewDelegate, UITableViewDataSource, XBTableViewControllerDelegate>

@property(nonatomic, strong, readonly) XECategory *category;

- (void)updateWithCategory:(XECategory *)category;
@end