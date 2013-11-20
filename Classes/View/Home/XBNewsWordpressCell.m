//
// Created by Alexis Kinsella on 21/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SDWebImage/UIImageView+WebCache.h>
#import "XBNewsWordpressCell.h"
#import "UIImage+XBAdditions.h"

@interface XBNewsWordpressCell ()

@property (nonatomic, strong, readwrite) UIImage *placeholderImage;

@end

@implementation XBNewsWordpressCell

- (void)configure {
    [super configure];
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.frame.size.width, CGFLOAT_MAX)];
    CGFloat height = 136 - 39 - 10 + size.height;

    if ( !self.news.imageUrl || [self.news.imageUrl length] == 0 ) {
        height = height - 50 - 10;
    }

    height = MAX(70, height);

    return height;
}

- (void)updateWithNews:(XBNews *)news {
    [super updateWithNews:news];

    if (news.imageUrl && news.imageUrl.length > 0) {
        __weak typeof(self) weakSelf = self;

        [self.excerptImageView setImageWithURL: [[NSURL alloc] initWithString:news.imageUrl]
                       placeholderImage: self.placeholderImage
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                  if (error || !image) {
                                      XBLog(@"Error: %@", error);
                                  }
                                  else {
                                      weakSelf.excerptImageView.image = [weakSelf resizeAndCropImage:image];
                                  }
                                  [weakSelf layoutSubviews];
                              }];
    }
}

- (UIImage *)resizeAndCropImage:(UIImage *)image {
    return [[image imageScaledToSize:CGSizeMake(50, 50)] imageCroppedInRect:CGRectMake(0, 0, 50, 50)];
}

- (void)onSelection {
    [super onSelection];

    NSURL * url  = [NSURL URLWithString:[NSString stringWithFormat: @"xebia://blog/posts/%@", self.news.typeId]];
    [[UIApplication sharedApplication] openURL: url];
}

@end