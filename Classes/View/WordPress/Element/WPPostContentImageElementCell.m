//
// Created by Alexis Kinsella on 22/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SDWebImage/UIImageView+WebCache.h>
#import "WPPostContentImageElementCell.h"

@interface WPPostContentImageElementCell()

@property (nonatomic, strong)UIImage *placeholderImage;

@end

@implementation WPPostContentImageElementCell

- (void)configure {

    [super configure];

    self.placeholderImage = [UIImage imageNamed:@"image-placeholder"];
}


- (void)updateWithWPPostContentElement:(WPPostContentStructuredElement *)element {
    [super updateWithWPPostContentElement:element];
    __weak typeof(self) weakSelf = self;

    NSString *imageSrc = self.element[@"src"];


    [self.imageView setImageWithURL:[NSURL URLWithString:imageSrc]
                   placeholderImage: self.placeholderImage
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                               if (error || !image) {
                                   XBLog(@"Error: %@", error);
                               }
                               else {
                                   if (!weakSelf.heightImageCache[imageSrc]) {
                                       weakSelf.heightImageCache[imageSrc] = @(image.size.height);
                                       [weakSelf.delegate reloadCellForElement:weakSelf.element];
                                   }
                               }
                              [weakSelf layoutSubviews];
                           }];

}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat maxImageWidth =  MIN(self.frame.size.width - 2 * 10, self.imageView.image.size.width);
    CGFloat imageWidthRatio = maxImageWidth / maxImageWidth;
    CGFloat imageWidthHeightRatio = self.imageView.image.size.width / self.imageView.image.size.width;

    CGRect imageFrame = CGRectMake(
            (self.frame.size.width - maxImageWidth - 10 * 2) / 2,
            10,
            maxImageWidth,
            maxImageWidth * imageWidthRatio / imageWidthHeightRatio
    );

    if (self.imageView.image.size.width + 2 * 10 > self.frame.size.width) {
        self.imageView.frame = imageFrame;
    }
    self.frame = CGRectMake(
            self.frame.origin.x,
            self.frame.origin.y,
            self.frame.size.width,
            self.imageView.image.size.height + 2 * 10
    );
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    NSString *imageSrc = self.element[@"src"];
    NSNumber *height = self.heightImageCache[imageSrc];

    return (height ? [height integerValue] : self.placeholderImage.size.height) + 2 * 10;
}

@end