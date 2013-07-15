//
//  WPCategoryCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPCategoryCell.h"
#import "UIColor+XBAdditions.h"
#import "WPCategory.h"
#import <QuartzCore/QuartzCore.h>

@interface WPCategoryCell()

@property(nonatomic, strong) WPCategory *category;

@end

@implementation WPCategoryCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void)updateWithCategory:(WPCategory *)category {
    
    self.category = category;
    
    self.titleLabel.text = category.title;
    self.bottomDetailLabel.text = [NSString stringWithFormat:
            category.postCount.intValue > 1 ? @"%d posts" : @"%d post",
            category.postCount
    ];

}

@end
