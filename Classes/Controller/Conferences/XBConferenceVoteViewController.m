//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceVoteViewController.h"
#import "XBConferencePresentationDetail.h"
#import "XBVote.h"


@implementation XBConferenceVoteViewController

- (NSString *)trackPath {
    return @"vote";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self applyValues];
}

- (void)applyValues {
    self.titleLabel.text = self.presentationDetail.title;
    self.subtitleLabel.text = NSLocalizedString(@"Vous pouvez voter en utilisant les boutons en bas", @"Vous pouvez voter en utilisant les boutons en bas");
}

- (IBAction)voteButton0Clicked:(id)sender {
    [self saveVote:XBVoteValueNegative];
}

- (IBAction)voteButton1Clicked:(id)sender {
    [self saveVote:XBVoteValueNeuter];
}

- (IBAction)voteButton2Clicked:(id)sender {
    [self saveVote:XBVoteValuePositive];
}

- (void)saveVote:(XBVoteValue)voteValue {
    XBVote *vote = [XBVote voteWithDateTaken:[NSDate date]
                                conferenceId:self.presentationDetail.conferenceId
                              presentationId:self.presentationDetail.identifier
                                       value:voteValue];
}

@end