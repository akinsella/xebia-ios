//
// Created by Simone Civetta on 10/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBTableViewController.h"
#import "XBSectionedTableViewController.h"


@interface XBConferenceHomeViewController : XBSectionedTableViewController<UITableViewDataSource, UITableViewDelegate, XBTableViewControllerDelegate>

- (void)initialize;

@end