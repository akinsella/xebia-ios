//
//  WPTagCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 26/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPTagCell.h"
#import "UIColor+XBAdditions.h"
#import "WPTag.h"
#import <QuartzCore/QuartzCore.h>

@interface WPTagCell()

@property(nonatomic, strong) WPTag *tag_;
@end

@implementation WPTagCell

- (void)updateWithTag:(WPTag *)tag {
    self.tag_ = tag;
    
    self.titleLabel.text = [tag capitalizedTitle];

    self.bottomDetailLabel.text = [NSString stringWithFormat: @"%@", tag.postCount];
}

@end
