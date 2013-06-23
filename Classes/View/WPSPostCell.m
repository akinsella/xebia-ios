//
//  WPSPostCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPSPostCell.h"
#import "SDImageCache.h"
#import "WPPost.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+XBAdditions.h"

@implementation WPSPostCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(9,16,44,44);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3.0;
}

@end
