//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XECardCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+XBAdditions.h"
#import "XBConstants.h"


@implementation XECardCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0,0,100,75);
    self.imageView.layer.masksToBounds = YES;
}

- (void)configure {
    self.descriptionLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    self.descriptionLabel.textColor = [UIColor colorWithHex:@"#fafafa" alpha:1.0];
    self.descriptionLabel.lineBreakMode = (NSLineBreakMode)UILineBreakModeTailTruncation;
    self.descriptionLabel.numberOfLines = 0;
}

@end