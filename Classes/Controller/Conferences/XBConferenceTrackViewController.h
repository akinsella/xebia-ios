//
// Created by Simone Civetta on 09/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBReloadableTableViewController.h"

@class XBConference;


@interface XBConferenceTrackViewController : XBReloadableTableViewController<UITableViewDataSource, UITableViewDelegate, XBTableViewControllerDelegate>

@property (nonatomic, strong) XBConference *conference;

@end