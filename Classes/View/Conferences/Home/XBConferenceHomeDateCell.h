//
// Created by Simone Civetta on 10/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBTableViewCell.h"


@interface XBConferenceHomeDateCell : XBTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *startDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *endDateLabel;

- (void)configureWithConference:(id)conference;

@end