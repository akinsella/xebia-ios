//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceRatingViewController.h"
#import "XBConferencePresentationDetail.h"
#import "XBConferenceRating.h"
#import "XBConferenceRatingManager.h"

@interface XBConferenceRatingViewController()

@property (nonatomic, strong) NSArray *ratingButtons;

@end

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
    self.ratingButtons = @[self.ratingButtonPoor, self.ratingButtonFair, self.ratingButtonGood, self.ratingButtonVeryGood, self.ratingButtonExcellent];
}

- (IBAction)ratingButtonClicked:(UIButton *)sender {
    [self saveRating:[self.ratingButtons indexOfObject:sender]];
    [[[UIAlertView alloc] initWithTitle:nil
                               message:NSLocalizedString(@"Your vote has been submitted", @"Your vote has been submitted")
                              delegate:nil
                     cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                     otherButtonTitles:nil] show];
}

- (void)saveRating:(XBConferenceRatingValue)ratingValue {
    XBConferenceRating *rating = [XBConferenceRating ratingWithDateTaken:[NSDate date]
                                                            conferenceId:self.presentationDetail.conferenceId
                                                          presentationId:self.presentationDetail.identifier
                                                                   value:ratingValue];
    [[XBConferenceRatingManager sharedManager] addRating:rating];
}

@end