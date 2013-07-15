//
//  WPAuthorCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPAuthorCell.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface WPAuthorCell ()
@property (nonatomic, strong) UIImage* defaultAvatarImage;
@property(nonatomic, strong) WPAuthor *author;
@end

@implementation WPAuthorCell

- (void)configure {

    [super configure];

    self.defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder"];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(8,8,44,44);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3.0;
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void)updateWithAuthor:(WPAuthor *)author {
    self.author = author;
    self.titleLabel.text = author.name;

    [self.imageView setImageWithURL:[author avatarImageUrl] placeholderImage:self.defaultAvatarImage];

}

@end
