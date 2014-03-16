//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceRatingCell.h"
#import "XBConferenceRating.h"
#import "XBConferencePresentation.h"


@implementation XBConferenceRatingCell

- (void)configureWithRating:(XBConferenceRating *)rating presentation:(XBConferencePresentation *)presentation {
    self.presentationTitleLabel.text = presentation.title;
    self.ratingLabel.text = rating.value.stringValue;
}

@end