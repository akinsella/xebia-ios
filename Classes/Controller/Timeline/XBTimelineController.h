//
//  XBTimelineController.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBTableViewController.h"
#import "XBReloadableTableViewController.h"

@interface XBTimelineController : XBReloadableTableViewController<UITableViewDelegate, UITableViewDataSource, XBTableViewControllerDelegate>

@end
