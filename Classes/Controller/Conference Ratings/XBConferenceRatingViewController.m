//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceRatingViewController.h"
#import "XBConferencePresentationDetail.h"
#import "XBConferenceRating.h"
#import "XBConferenceRatingManager.h"


@implementation XBConferenceRatingViewController

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
    [self saveVote:XBConferenceRatingValueNegative];
}

- (IBAction)voteButton1Clicked:(id)sender {
    [self saveVote:XBConferenceRatingValueNeuter];
}

- (IBAction)voteButton2Clicked:(id)sender {
    [self saveVote:XBConferenceRatingValuePositive];
}

- (void)saveVote:(XBConferenceRatingValue)voteValue {
    XBConferenceRating *rating = [XBConferenceRating ratingWithDateTaken:[NSDate date]
                                                            conferenceId:self.presentationDetail.conferenceId
                                                          presentationId:self.presentationDetail.identifier
                                                                   value:voteValue];
    [[XBConferenceRatingManager sharedManager] addRating:rating];
}

@end