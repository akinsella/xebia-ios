//
// Created by Simone Civetta on 10/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceHomeDateCell.h"
#import "XBConference.h"

@interface XBConferenceHomeDateCell()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation XBConferenceHomeDateCell

- (NSDateFormatter *)dateFormatter {
    static dispatch_once_t once;
    static NSDateFormatter *sharedConferenceHomeDateCellDateFormatter;
    dispatch_once(&once, ^ {
        sharedConferenceHomeDateCellDateFormatter = [[NSDateFormatter alloc] init];
        sharedConferenceHomeDateCellDateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
        sharedConferenceHomeDateCellDateFormatter.dateFormat = @"EEEE dd/MM/YYYY";
    });
    return sharedConferenceHomeDateCellDateFormatter;
}

- (void)configureWithConference:(XBConference *)conference {
    self.accessoryType = UITableViewCellAccessoryNone;
    self.startDateLabel.text = [[self.dateFormatter stringFromDate:conference.from] capitalizedString];
    self.endDateLabel.text = [[self.dateFormatter stringFromDate:conference.to] capitalizedString];
}

@end