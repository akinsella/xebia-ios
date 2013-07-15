//
// Created by Alexis Kinsella on 16/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XEAbstractCell.h"
#import "XECategory.h"
#import "UIColor+XBAdditions.h"
#import <QuartzCore/QuartzCore.h>


@interface XBTableViewCell()

@property (nonatomic, strong)XECategory *category;

@end

@implementation XEAbstractCell

- (void)configure {
    [super configure];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextClipToRect(ctx, CGRectMake(rect.origin.x, rect.origin.y, 6, rect.size.height));
    CGContextSetFillColorWithColor(ctx, self.leftBorderColor.CGColor);

    CGContextFillRect(ctx, rect);
}

- (UIColor *)leftBorderColor {
    if (self.category) {
        return [UIColor colorWithHex:self.category.color];
    }
    else {
        return [UIColor clearColor];
    }
}

@end