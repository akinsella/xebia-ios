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
                            options:kNilOptions
                            success:^(UIImage *image) {
                                if (!weakSelf.heightImageCache[imageSrc]) {
                                    weakSelf.heightImageCache[imageSrc] = @(image.size.height);
                                    [weakSelf.delegate reloadCellForElement:weakSelf.element];
                                }
                                [weakSelf layoutSubviews];
                            }
                            failure:^(NSError *error) {
                                [weakSelf layoutSubviews];
                            }
    ];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(
            (self.frame.size.width - MIN(self.frame.size.width, self.imageView.image.size.width)) / 2,
            10,
            self.imageView.image.size.width,
            self.imageView.image.size.height
    );
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