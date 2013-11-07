//
//  TTTweetTableViewController.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "XBReloadableTableViewController.h"
#import "XBNavigableViewController.h"

@interface TTTweetTableViewController : XBReloadableTableViewController<UITableViewDelegate, UITableViewDataSource, XBTableViewControllerDelegate, XBNavigableViewController>

@end
