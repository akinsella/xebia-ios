//
//  XBConferenceDayViewController.h
//  Xebia
//
//  Created by Simone Civetta on 21/02/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBTableViewController.h"
#import "XBConference.h"
#import "XBSectionedTableViewController.h"

@interface XBConferenceDayViewController : XBSectionedTableViewController<UITableViewDataSource, UITableViewDelegate, XBTableViewControllerDelegate>

@property (nonatomic, strong) NSDate *day;
@property (nonatomic, strong) XBConference *conference;

@property (nonatomic, weak) IBOutlet UILabel *dayLabel;

@end
