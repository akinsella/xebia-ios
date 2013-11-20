//
// Created by Alexis Kinsella on 21/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SDWebImage/UIImageView+WebCache.h>
#import "XBNewsOtherCell.h"

@interface XBNewsOtherCell ()

@property (nonatomic, strong, readwrite) UIImage *placeholderImage;

@end

@implementation XBNewsOtherCell

- (CGFloat)heightForCell:(UITableView *)tableView {
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.frame.size.width, CGFLOAT_MAX)];
    CGFloat height = 36 - 21 + size.height;
    
    height = MAX(70, height);
    
    return height;
}

- (void)updateWithNews:(XBNews *)news {
    [super updateWithNews:news];
}

- (void)onSelection {
    [super onSelection];
    
    NSURL *url = [NSURL URLWithString: self.news.targetUrl];
    [[UIApplication sharedApplication] openURL: url];
}

@end