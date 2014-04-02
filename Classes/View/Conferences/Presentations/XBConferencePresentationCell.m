//
//  XBConferencePresentationCell.m
//  Xebia
//
//  Created by Simone Civetta on 16/02/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import <SSToolkit/UIColor+SSToolkitAdditions.h>
#import "XBConferencePresentationCell.h"
#import "XBConferencePresentation.h"

@implementation XBConferencePresentationCell

- (NSDateFormatter *)dateFormatter {
    static dispatch_once_t once;
    static NSDateFormatter *sharedConferenceHomeDateCellDateFormatter;
    dispatch_once(&once, ^ {
        sharedConferenceHomeDateCellDateFormatter = [[NSDateFormatter alloc] init];
        sharedConferenceHomeDateCellDateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"fr_FR"];
        sharedConferenceHomeDateCellDateFormatter.dateFormat = @"HH'h'mm";
    });
    return sharedConferenceHomeDateCellDateFormatter;
}

- (void)configureWithPresentation:(XBConferencePresentation *)presentation {
    if ([presentation isAuxiliary]) {
        self.titleLabel.text = presentation.kind;
        self.backgroundColor = [UIColor whiteColor];
        self.speakerLabel.text = @"";
        self.hourLabel.text = [self.dateFormatter stringFromDate:presentation.fromTime];
        self.accessoryType = UITableViewCellAccessoryNone;
    } else {
        self.titleLabel.text = presentation.title;
        self.speakerLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"par", @"par"), presentation.speakerString];
        self.backgroundColor = [UIColor colorWithHex:@"#F0F0F0"];
        self.hourLabel.text = nil;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    return 11 + self.titleLabel.intrinsicContentSize.height + ([self.speakerLabel.text length] ? 4 + self.speakerLabel.intrinsicContentSize.height : 0) + 11;
}

@end
