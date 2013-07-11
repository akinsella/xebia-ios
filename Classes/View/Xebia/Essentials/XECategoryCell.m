//
// Created by Alexis Kinsella on 11/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XECategoryCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation XECategoryCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0,0,100,44);
    self.imageView.layer.masksToBounds = YES;
}

- (void)configure {

}

@end