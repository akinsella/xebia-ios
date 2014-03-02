//
//  XBConferenceRoomViewController.h
//  Xebia
//
//  Created by Simone Civetta on 29/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBLoadableTableViewController.h"
#import "XBTableViewController.h"

@class XBConference;

@interface XBConferenceRoomViewController : XBLoadableTableViewController<UITableViewDataSource, UITableViewDelegate, XBTableViewControllerDelegate>

@property (nonatomic, strong) XBConference *conference;

@end
