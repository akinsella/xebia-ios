//
//  TTTweetTableViewController.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "XBTableViewController.h"

@interface TTTweetTableViewController : XBTableViewController<UITableViewDelegate, UITableViewDataSource, TTTAttributedLabelDelegate, XBTableViewControllerDelegate>

@end
