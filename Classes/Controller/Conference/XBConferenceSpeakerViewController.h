//
// Created by Simone Civetta on 26/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBTableViewController.h"
#import "XBReloadableTableViewController.h"

@class XBConference;


@interface XBConferenceSpeakerViewController : XBReloadableTableViewController<UITableViewDataSource, UITableViewDelegate, XBTableViewControllerDelegate>

@property (nonatomic, strong) XBConference *conference;

@end