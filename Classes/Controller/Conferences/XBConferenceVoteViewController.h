//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBViewController.h"

@class XBConferencePresentationDetail;


@interface XBConferenceVoteViewController : XBViewController

@property (nonatomic, strong) XBConferencePresentationDetail *presentationDetail;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UIButton *voteButton0;
@property (nonatomic, weak) IBOutlet UIButton *voteButton1;
@property (nonatomic, weak) IBOutlet UIButton *voteButton2;

- (IBAction)voteButton0Clicked:(id)sender;
- (IBAction)voteButton1Clicked:(id)sender;
- (IBAction)voteButton2Clicked:(id)sender;

@end