//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBTableViewCell.h"

@class XBConferenceRating;
@class XBConferencePresentation;


@interface XBConferenceRatingCell : XBTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *presentationTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *ratingLabel;

- (void)configureWithRating:(XBConferenceRating *)rating presentation:(XBConferencePresentation *)presentation;

@end