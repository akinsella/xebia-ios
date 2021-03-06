//
//  XBLeftMenuCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 26/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XBLeftMenuCell.h"
#import "UIColor+XBAdditions.h"

@implementation XBLeftMenuCell

- (BOOL)showSeparatorLine {
    return NO;
}

- (BOOL)showSelectedSeparatorLine {
    return NO;
}

- (UIColor *)customizedBackgroundColor {
    return [UIColor colorWithHex:@"#222222"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10,10,22,22);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3.0;

    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0]];
    [self.textLabel setTextColor: [UIColor whiteColor]];
    [self.textLabel setShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75]];
    [self.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
}

@end
