//
// Created by Simone Civetta on 16/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBLoadableTableViewController.h"

@class XBConferenceTrack;
@class XBConference;
@class DTAttributedTextContentView;


@interface XBConferenceTrackDetailViewController : XBLoadableTableViewController<UITableViewDataSource, UITableViewDelegate, XBTableViewControllerDelegate>

@property (nonatomic, strong) XBConferenceTrack *track;
@property (nonatomic, strong) XBConference *conference;

@property (nonatomic, weak) IBOutlet UIView *trackHeaderView;
@property (nonatomic, weak) IBOutlet UILabel *trackTitleLabel;
@property (nonatomic, weak) IBOutlet DTAttributedTextContentView *trackDescriptionLabel;

@end