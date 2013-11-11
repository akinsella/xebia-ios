//
// Created by Alexis Kinsella on 21/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SDWebImage/UIImageView+WebCache.h>
#import "XBNewsWordpressCell.h"

@interface XBNewsWordpressCell ()

@property (nonatomic, strong, readwrite) UIImage *placeholderImage;

@end

@implementation XBNewsWordpressCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 3, 130, 130);
    self.imageView.layer.masksToBounds = YES;
}

- (void)updateWithNews:(XBNews *)news {
    [super updateWithNews:news];

    if (news.imageUrl) {
        __weak typeof(self) weakSelf = self;

        [self.imageView setImageWithURL: [[NSURL alloc] initWithString:news.imageUrl]
                       placeholderImage: self.placeholderImage
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                  if (error || !image) {
                                      XBLog(@"Error: %@", error);
                                  }
                                  else {
                                      CGRect cropRect = CGRectMake(0, 0, 130, 130);
                                      CGImageRef croppedImageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect);

                                      UIImage *croppedImage = [UIImage imageWithCGImage:croppedImageRef];
                                      CGImageRelease(croppedImageRef);

                                      weakSelf.imageView.image = croppedImage;
                                  }
                                  [weakSelf layoutSubviews];
                              }];
    }
}

- (void)onSelection {
    [super onSelection];

    NSURL * url  = [NSURL URLWithString:[NSString stringWithFormat: @"xebia://blog/posts/%@", self.news.identifier]];
    [[UIApplication sharedApplication] openURL: url];
}

@end