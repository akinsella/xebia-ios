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

- (void)updateWithNews:(XBNews *)news {
    [super updateWithNews:news];

    if (news.imageUrl) {
        __weak typeof(self) weakSelf = self;
        [self.imageView setImageWithURL: [[NSURL alloc] initWithString:news.imageUrl]
                       placeholderImage: self.placeholderImage
                                options: kNilOptions
                                success: ^(UIImage *image) {
                                    CGRect cropRect = CGRectMake(0, 0, weakSelf.frame.size.width, weakSelf.frame.size.height);
                                    CGImageRef croppedImageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect);

                                    UIImage *croppedImage = [UIImage imageWithCGImage:croppedImageRef];
                                    CGImageRelease(croppedImageRef);

                                    weakSelf.imageView.image = croppedImage;
                                }
                                failure: ^(NSError *error) {
                                    [weakSelf layoutSubviews];
                                }
        ];
    }
}

@end