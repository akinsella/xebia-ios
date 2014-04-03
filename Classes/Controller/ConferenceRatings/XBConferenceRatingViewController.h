//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBViewController.h"

@class XBConferencePresentationDetail;
@class XBConferenceRating;


@interface XBConferenceRatingViewController : XBViewController

@property (nonatomic, strong) XBConferencePresentationDetail *presentationDetail;
@property (nonatomic, strong) XBConferenceRating *rating;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

@property (nonatomic, weak) IBOutlet UIButton *ratingButtonPoor;
@property (nonatomic, weak) IBOutlet UIButton *ratingButtonFair;
@property (nonatomic, weak) IBOutlet UIButton *ratingButtonGood;
@property (nonatomic, weak) IBOutlet UIButton *ratingButtonVeryGood;
@property (nonatomic, weak) IBOutlet UIButton *ratingButtonExcellent;

@end