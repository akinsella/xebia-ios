//
// Created by Alexis Kinsella on 22/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "WPPostContentHeaderElementCell.h"
#import "UIColor+XBAdditions.h"


@implementation WPPostContentHeaderElementCell


- (void)updateWithWPPostContentElement:(WPPostContentStructuredElement *)element {
    [super updateWithWPPostContentElement:element];

    self.headerLabel.font = [UIFont fontWithName:@"@Helvetica-Bold" size:10 + [self headerIndex]];
    self.headerLabel.textColor = [UIColor colorWithHex:@"#4F2642"];
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

@end