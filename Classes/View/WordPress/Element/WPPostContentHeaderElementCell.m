//
// Created by Alexis Kinsella on 22/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "WPPostContentHeaderElementCell.h"
#import "UIColor+XBAdditions.h"

static const CGFloat kMarginWidth = 25.0;
static const CGFloat kMarginHeight = 25.0;

@implementation WPPostContentHeaderElementCell

- (void)updateWithWPPostContentElement:(WPPostContentStructuredElement *)element {
    [super updateWithWPPostContentElement:element];

    self.headerLabel.font = [UIFont fontWithName:@"Cabin" size: 11 + ( 6 * 2 - self.headerIndex * 2)];
    self.headerLabel.textColor = [UIColor colorWithHex:@"#8b6ba3"];
    self.headerLabel.text = [self.element.text uppercaseString];
//    self.backgroundColor = self.headerIndex > 3 ? [UIColor redColor]: [UIColor blueColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize headerLabelSize = [self sizeThatFits];
    self.headerLabel.frame = CGRectMake(
            [self headerIndent],
            0,
            headerLabelSize.width,
            headerLabelSize.height
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

- (CGFloat)headerIndent {
    //([self headerIndex] - 1) * kMarginWidth;
    return kMarginWidth;
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    return [self sizeThatFits].height + 2 * kMarginHeight;
}

- (CGSize)sizeThatFits {
    return [self.headerLabel sizeThatFits:CGSizeMake(self.frame.size.width - (self.headerIndent), CGFLOAT_MAX)];
}

@end