//
// Created by Simone Civetta on 22/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBViewController.h"
#import "XBConferencePresentation.h"
#import "XBConference.h"

@interface XBConferencePresentationDetailViewController : XBViewController

@property (nonatomic, strong) NSNumber *presentationIdentifier;
@property (nonatomic, strong) XBConference *conference;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *summaryLabel;
@property (nonatomic, weak) IBOutlet UILabel *trackLabel;
@property (nonatomic, weak) IBOutlet UILabel *speakerLabel;

@property (nonatomic, weak) IBOutlet UIButton *voteButton;

@end