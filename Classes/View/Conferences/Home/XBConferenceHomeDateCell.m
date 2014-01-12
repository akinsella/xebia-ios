//
// Created by Simone Civetta on 10/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceHomeDateCell.h"

@interface XBConferenceHomeDateCell()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation XBConferenceHomeDateCell {

}

- (NSDateFormatter *)dateFormatter {
    static dispatch_once_t once;
    static NSDateFormatter *sharedConferenceHomeDateCellDateFormatter;
    dispatch_once(&once, ^ {
        sharedConferenceHomeDateCellDateFormatter = [[NSDateFormatter alloc] init];
        sharedConferenceHomeDateCellDateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"fr_FR"];
        sharedConferenceHomeDateCellDateFormatter.dateFormat = @"dd/MM/YYYY";
    });
    return sharedConferenceHomeDateCellDateFormatter;
}

- (void)configureWithConference:(id)conference {
    self.accessoryType = UITableViewCellAccessoryNone;
    self.startDateLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
    self.endDateLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
}

@end