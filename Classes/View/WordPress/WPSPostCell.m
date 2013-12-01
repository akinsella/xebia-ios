//
//  WPSPostCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPSPostCell.h"
#import "SDImageCache.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
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
    self.avatarImageView.backgroundImage = [UIImage imageNamed:@"dp_holder_large"];
    self.avatarImageView.defaultImage = self.defaultPostImage;
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    CGFloat labelsHeight = self.titleLabelHeight.height;
    CGFloat height = 64 - 21 + labelsHeight;

    height = MAX(64, height);

    return height;
}

- (CGSize)titleLabelHeight {
    return [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.frame.size.width, CGFLOAT_MAX)];
}

- (void)updateWithPost:(WPPost *)post {

    self.post = post;
    
    self.titleLabel.text = post.title;

    NSCalendar *cal = [[NSCalendar alloc] init];
    NSDateComponents *postDateComponents = [cal components:0 fromDate:post.date];
    NSDateComponents *currentDateComponents = [cal components:0 fromDate:[NSDate date]];
    int postDateYear = [postDateComponents year];
    int currentDateYear = [postDateComponents year];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [post.date formatAuto]];


    self.categoriesLabel.text = post.categoriesFormatted;
    self.authorLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"By", nil), post.authorFormatted];

    if (![post.primaryAuthor.slug isEqualToString:@"xebiafrance"]) {

        [[SDWebImageManager sharedManager] downloadWithURL:post.imageUrl
                                                   options:kNilOptions
                                                  progress:^(NSUInteger receivedSize, long long int expectedSize) {

                                                  }
                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                     if (error || !image) {
                                                         self.avatarImageView.image = self.defaultPostImage;
                                                     }
                                                     else {
                                                         self.avatarImageView.image = image;
                                                     }
                                                 }];
    }
    else {
        self.avatarImageView.image = self.xebiaPostImage;
    }

}

@end
