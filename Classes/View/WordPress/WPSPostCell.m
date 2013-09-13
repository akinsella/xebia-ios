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
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+XBAdditions.h"
#import "NSDate+XBAdditions.h"

@interface WPSPostCell ()
@property (nonatomic, strong) UIImage *defaultPostImage;
@property (nonatomic, strong) UIImage *xebiaPostImage;
@property(nonatomic, strong) WPPost *post;
@end

@implementation WPSPostCell

- (void)configure {

    [super configure];

    self.defaultPostImage = [UIImage imageNamed:@"avatar_placeholder"];
    self.xebiaPostImage = [UIImage imageNamed:@"xebia-avatar"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarImageView.offset = 2;
    self.avatarImageView.backgroundColor = [UIColor clearColor];
    self.avatarImageView.backgroundImage = [UIImage imageNamed:@"dp_holder_large.png"];
    self.avatarImageView.defaultImage = self.defaultPostImage;
}

- (void)updateWithPost:(WPPost *)post {

    self.post = post;
    
    self.titleLabel.text = post.title;
    self.dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Le %@", nil), [post.date formatDate]];
    self.categoriesLabel.text = post.categoriesFormatted;
    self.authorLabel.text = post.authorFormatted;

    if (![post.primaryAuthor.slug isEqualToString:@"xebiafrance"]) {
        [[SDWebImageManager sharedManager] downloadWithURL:post.imageUrl
                                                  delegate:self
                                                   options:kNilOptions
                                                   success:^(UIImage *image) {
                                                       self.avatarImageView.image = image;
                                                   }
                                                   failure:^(NSError *error) {
                                                       self.avatarImageView.image = self.defaultPostImage;
                                                   }];
    }
    else {
        self.avatarImageView.image = self.xebiaPostImage;
    }

}

@end
