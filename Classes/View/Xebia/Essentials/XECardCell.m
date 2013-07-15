//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XECardCell.h"
#import "XECard.h"
#import "XECategory.h"
#import "UIColor+XBAdditions.h"
#import <QuartzCore/QuartzCore.h>

@implementation XECardCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0,0,100,75);
    self.imageView.layer.masksToBounds = YES;
}

- (void)updateWithCard:(XECard *)card {
    self.card = card;
    self.titleLabel.text = card.title;
}

- (XECategory *)category {
    return self.card.category;
}

@end