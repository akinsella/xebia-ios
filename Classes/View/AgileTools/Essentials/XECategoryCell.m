//
// Created by Alexis Kinsella on 11/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XECategoryCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation XECategoryCell

- (NSInteger)leftLineSeparatorMargin {
    return 6;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0,0,100,44);
    self.imageView.layer.masksToBounds = YES;
}

- (void)updateWithCategory:(XECategory *)category {
    self.category = category;
    self.titleLabel.text = category.label;
}

@end