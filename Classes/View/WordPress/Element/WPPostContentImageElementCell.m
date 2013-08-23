//
// Created by Alexis Kinsella on 22/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SDWebImage/UIImageView+WebCache.h>
#import "WPPostContentImageElementCell.h"

@implementation WPPostContentImageElementCell


- (void)updateWithWPPostContentElement:(WPPostContentStructuredElement *)element {
    [super updateWithWPPostContentElement:element];
    __weak typeof(self) weakSelf = self;

    [self.imageView setImageWithURL: self.element[@"src"]
                   placeholderImage:[UIImage imageNamed:@"image-placeholder"]
                            options:kNilOptions
                            success:^(UIImage *image) {
                                [weakSelf layoutSubviews];
                            }
                            failure:^(NSError *error) {
                                [weakSelf layoutSubviews];
                            }
    ];
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    return self.imageView.image.size.height + 2 * 10;
}

@end