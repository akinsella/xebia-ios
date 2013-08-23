//
// Created by Alexis Kinsella on 22/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "WPPostContentHeaderElementCell.h"
#import "UIColor+XBAdditions.h"

static const int kMarginWidth = 5;
static const int kMarginHeight = 5;

@implementation WPPostContentHeaderElementCell

- (void)updateWithWPPostContentElement:(WPPostContentStructuredElement *)element {
    [super updateWithWPPostContentElement:element];

    self.headerLabel.font = [UIFont fontWithName:@"@Helvetica-Bold" size: 11 + ( 6 * 2 - [self headerIndex] * 2)];
    self.headerLabel.textColor = [UIColor colorWithHex:@"#2c3e50"];
    self.headerLabel.text = [self.element.text uppercaseString];
    self.headerLabel.frame = CGRectMake(
            [self headerIndent],
            0,
            self.frame.size.width - ([self headerIndent] * 2),
            self.frame.size.height
    );
}

- (NSUInteger)headerIndex {
    if ([self.element.type isEqualToString:@"H1"]) {
        return 1;
    }
    else if ([self.element.type isEqualToString:@"H2"]) {
        return 2;
    }
    else if ([self.element.type isEqualToString:@"H3"]) {
        return 3;
    }
    else if ([self.element.type isEqualToString:@"H4"]) {
        return 4;
    }
    else if ([self.element.type isEqualToString:@"H5"]) {
        return 5;
    }
    else if ([self.element.type isEqualToString:@"H6"]) {
        return 6;
    }
    else {
        return 0;
    }
}

- (NSUInteger)headerIndent {
    return ([self headerIndex] - 1) * kMarginWidth;
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    return [self.headerLabel sizeThatFits:CGSizeMake(self.frame.size.width - ([self headerIndent] * 2), CGFLOAT_MAX)].height + kMarginHeight * 2;
}

@end