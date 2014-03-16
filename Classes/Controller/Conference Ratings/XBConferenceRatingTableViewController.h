//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBTableViewController.h"

@class XBConference;


@interface XBConferenceRatingTableViewController : XBTableViewController<XBTableViewControllerDelegate>

@property (nonatomic, strong) XBConference *conference;

@end