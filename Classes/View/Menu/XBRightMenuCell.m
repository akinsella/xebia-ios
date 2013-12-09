//
//  XBLeftMenuCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 26/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XBRightMenuCell.h"
#import "UIColor+XBAdditions.h"
#import "XBConstants.h"

@implementation XBRightMenuCell

- (BOOL)showSeparatorLine {
    return NO;
}

- (BOOL)showSelectedSeparatorLine {
    return NO;
}

- (UIColor *)customizedBackgroundColor {
    return [UIColor colorWithHex:@"#222222"];
}

- (UIColor *)gradientLayerColor {
    return [UIColor colorWithHex:@"#6a205f"];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (IS_IPAD) {
        self.titleLabel.frame = CGRectMake(520,  self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
        self.imageView.frame = CGRectMake(490,10,22,22);
    }
    else {
        self.imageView.frame = CGRectMake(42,10,22,22);
    }

    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3.0;

    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

@end
