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

- (NSDateFormatter *)dateFormatter {
    static dispatch_once_t once;
    static NSDateFormatter *sharedConferenceHomeDateCellDateFormatter;
    dispatch_once(&once, ^ {
        sharedConferenceHomeDateCellDateFormatter = [[NSDateFormatter alloc] init];
        sharedConferenceHomeDateCellDateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"fr_FR"];
        sharedConferenceHomeDateCellDateFormatter.dateFormat = @"dd LLLL YYYY";
    });
    return sharedConferenceHomeDateCellDateFormatter;
}

- (void)configureWithDay:(NSDate *)day {
    self.titleLabel.text = [self.dateFormatter stringFromDate:day];
}

@end