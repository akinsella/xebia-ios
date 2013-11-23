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

    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    XBLog("Default - %@", self.avatarImageView.image);
    self.avatarImageView.offset = 2;
    self.avatarImageView.backgroundColor = [UIColor clearColor];
    self.avatarImageView.backgroundImage = [UIImage imageNamed:@"dp_holder_large"];
    self.avatarImageView.defaultImage = self.defaultAvatarImage;
}

- (void)updateWithAuthor:(WPAuthor *)author {
    self.author = author;
    self.titleLabel.text = author.name;

    XBLog(@"Avatar image url: %@", author.avatarImageUrl);

    [[SDWebImageManager sharedManager] downloadWithURL:author.avatarImageUrl
                                               options:kNilOptions
                                              progress:^(NSUInteger receivedSize, long long int expectedSize) {

                                              }
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (error || !image) {
                                                     XBLog("Error - %@ for: %@", error, author.nickname);
                                                     self.avatarImageView.image = self.defaultAvatarImage;
                                                 }
                                                 else {
                                                     XBLog("Success - %@ for: %@", image, author.nickname);
                                                     self.avatarImageView.image = image;
                                                 }
                                             }];

}

@end
