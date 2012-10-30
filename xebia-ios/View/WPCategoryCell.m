//
//  WPCategoryCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPCategoryCell.h"
#import "UIColor+XBAdditions.h"

@implementation WPCategoryCell

- (void)setItemCount:(NSInteger)itemCount {
    _itemCount = itemCount;
    [self updateBottomDetailLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dashedSeparatorView.backgroundColor = [UIColor colorWithPatternImageName:@"dashed-separator"];
}

- (void)updateBottomDetailLabel {
    self.bottomDetailLabel.text = [NSString stringWithFormat: 
                                   self.itemCount > 1 ? @"%d posts" : @"%d post", 
                                   self.itemCount];
}

@end
