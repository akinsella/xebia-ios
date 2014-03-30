//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <SSToolkit/UIColor+SSToolkitAdditions.h>
#import "XBConferenceRatingViewController.h"
#import "XBConferencePresentationDetail.h"
#import "XBConferenceRating.h"
#import "XBConferenceRatingManager.h"
#import "XBConference.h"

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
    self.view.backgroundColor = [UIColor colorWithHex:@"#F0F0F0"];
}


- (void)applyValues {
    self.rating = [[XBConferenceRatingManager sharedManager] ratingForPresentation:self.presentationDetail];
    self.titleLabel.text = self.presentationDetail.title;
    self.subtitleLabel.text = NSLocalizedString(@"Vous pouvez voter en utilisant les boutons en bas", @"Vous pouvez voter en utilisant les boutons en bas");
    self.ratingButtons = @[self.ratingButtonPoor, self.ratingButtonFair, self.ratingButtonGood, self.ratingButtonVeryGood, self.ratingButtonExcellent];

    if (self.rating) {
        [self selectRatingButtonsForValue:[self.rating.value intValue]];
    }
}

- (IBAction)ratingButtonClicked:(UIButton *)sender {
    [self applyRatingWithValue:[self.ratingButtons indexOfObject:sender]];
}

- (void)selectRatingButtonsForValue:(XBConferenceRatingValue)value {
    for (int i = 0; i < [self.ratingButtons count]; i++) {
        [self.ratingButtons[i] setSelected:(i <= value)];
    }
}

- (void)applyRatingWithValue:(XBConferenceRatingValue)value {
    [self selectRatingButtonsForValue:value];
    [self saveRating:value];
}

- (void)saveRating:(XBConferenceRatingValue)ratingValue {
    XBConferenceRating *rating = [XBConferenceRating ratingWithDateTaken:[NSDate date]
                                                            conferenceId:self.presentationDetail.conferenceId
                                                          presentationId:self.presentationDetail.identifier
                                                                   value:ratingValue];
    self.rating = rating;
    [[XBConferenceRatingManager sharedManager] addRating:rating];
}

@end