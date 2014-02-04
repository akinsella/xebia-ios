//
//  XBConferenceHomeDayCell.m
//  Xebia
//
//  Created by Simone Civetta on 12/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceHomeDayCell.h"
#import "XBConferencePresentation.h"
#import "NSDateFormatter+XBAdditions.h"

@implementation XBConferenceHomeDayCell

- (void)configureWithPresentation:(XBConferencePresentation *)presentation {
    NSDateFormatter *formatter = [NSDateFormatter initWithDateFormat:@"dd/MM/YYYY"];
    self.titleLabel.text = [formatter stringFromDate:presentation.fromTime];
}

@end
