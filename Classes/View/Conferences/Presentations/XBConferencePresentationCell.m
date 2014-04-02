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
#import "UIColor+XBConferenceAdditions.h"

@interface XBConferencePresentationCell()

@property (nonatomic, strong) CALayer *colorLayer;

@end

@implementation XBConferencePresentationCell

- (NSDateFormatter *)dateFormatter {
    static dispatch_once_t once;
    static NSDateFormatter *sharedConferenceHomeDateCellDateFormatter;
    dispatch_once(&once, ^ {
        sharedConferenceHomeDateCellDateFormatter = [[NSDateFormatter alloc] init];
        sharedConferenceHomeDateCellDateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
        sharedConferenceHomeDateCellDateFormatter.dateFormat = @"HH'h'mm";
    });
    return sharedConferenceHomeDateCellDateFormatter;
}


- (void)awakeFromNib {
    if (!self.colorLayer) {
        CALayer *colorLayer = [[CALayer alloc] init];
        colorLayer.frame = CGRectMake(0, 0, 6, 6);
        [self.layer addSublayer:colorLayer];
        self.colorLayer = colorLayer;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.colorLayer.frame = CGRectMake(0, 0, 6, CGRectGetHeight(self.frame) + 1);
}

- (void)configureWithPresentation:(XBConferencePresentation *)presentation {
    if ([presentation isAuxiliary]) {
        self.titleLabel.text = presentation.kind;
        self.backgroundColor = [UIColor whiteColor];
        self.speakerLabel.text = @"";
        self.hourLabel.text = [self.dateFormatter stringFromDate:presentation.fromTime];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.colorLayer.backgroundColor = [UIColor clearColor].CGColor;
    } else {
        self.titleLabel.text = presentation.title;
        self.speakerLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"par", @"par"), presentation.speakerString];
        self.backgroundColor = [UIColor colorWithHex:@"#F0F0F0"];
        self.hourLabel.text = nil;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.colorLayer.backgroundColor = [UIColor colorWithTrackIdentifier:presentation.track].CGColor;
    }
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    return 11 + self.titleLabel.intrinsicContentSize.height + ([self.speakerLabel.text length] ? 4 + self.speakerLabel.intrinsicContentSize.height : 0) + 11;
}

@end
