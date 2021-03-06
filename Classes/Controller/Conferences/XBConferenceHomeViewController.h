//
// Created by Simone Civetta on 10/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBTableViewController.h"
#import "XBSectionedTableViewController.h"

@class XBConference;


@interface XBConferenceHomeViewController : XBSectionedTableViewController<UITableViewDataSource, UITableViewDelegate, XBTableViewControllerDelegate>

@property (nonatomic, strong, readonly) XBConference *conference;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *downloadActivityIndicator;

- (void)initialize;

- (void)updateWithConference:(XBConference *)conference;
@end