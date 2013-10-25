//
// Created by Alexis Kinsella on 21/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "XBNewsCell.h"
#import "XBConstants.h"
#import "UIColor+XBAdditions.h"
#import "UIImageView+AFNetworking.h"

@interface XBNewsCell ()

@property (nonatomic, strong, readwrite) UIImage *defaultImage;
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong) XBNews *news;

@end
@implementation XBNewsCell

- (void)configure {

    [super configure];

    self.defaultImage = [UIImage imageNamed:@"avatar_placeholder"];

    self.accessoryType = UITableViewCellAccessoryNone;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, 137);
    self.imageView.layer.masksToBounds = YES;

    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.imageView.image = nil;
    self.titleLabel.text = nil;
}

- (void)updateWithNews:(XBNews *)news {
    self.news = news;
    self.titleLabel.text = news.title;

    self.titleView.backgroundColor = [UIColor colorWithHex:@"#000000" alpha:0.25];

    if (news.targetUrl) {
        NSURL *url = [[NSURL alloc] initWithString:news.targetUrl];
        [self.imageView setImageWithURL: url placeholderImage:self.defaultImage];
    }
}

@end