//
// Created by Simone Civetta on 16/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBReloadableTableViewController.h"

@class XBConferenceTrack;
@class XBConference;
@class DTAttributedTextContentView;
@class XBConferenceRoom;


@interface XBConferenceRoomDetailViewController : XBReloadableTableViewController<UITableViewDataSource, UITableViewDelegate, XBTableViewControllerDelegate>

@property (nonatomic, strong) XBConferenceRoom *room;
@property (nonatomic, strong) XBConference *conference;

@property (nonatomic, weak) IBOutlet UIView *roomHeaderView;
@property (nonatomic, weak) IBOutlet UILabel *roomNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *roomLocationNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *roomCapacityLabel;

@end