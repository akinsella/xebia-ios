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

- (void)awakeFromNib {
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)configureWithPresentation:(XBConferencePresentation *)presentation {
    if (![presentation.title length]) {
        self.titleLabel.text = presentation.kind;
        self.backgroundColor = [UIColor whiteColor];
        self.speakerLabel.text = @"";
    } else {
        self.titleLabel.text = presentation.title;
        self.speakerLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"par", @"par"), presentation.speakerString];
        self.backgroundColor = [UIColor colorWithHex:@"#F0F0F0"];
    }
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    return 11 + self.titleLabel.intrinsicContentSize.height + ([self.speakerLabel.text length] ? 4 + self.speakerLabel.intrinsicContentSize.height : 0) + 11;
}

@end
