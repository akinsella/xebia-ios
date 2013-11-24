//
// Created by Alexis Kinsella on 21/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "XBNewsEventBriteCell.h"

@implementation XBNewsEventBriteCell

- (CGFloat)heightForCell:(UITableView *)tableView {
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.frame.size.width, CGFLOAT_MAX)];
    CGFloat height = 36 - 21 + size.height;
    
    height = MAX(70, height);
    
    return height;
}

- (void)updateWithNews:(XBNews *)news {
    [super updateWithNews:news];
    [self.titleLabel sizeToFit];
}

- (void)onSelection {
    [super onSelection];
    
    NSURL * url  = [NSURL URLWithString:[NSString stringWithFormat: @"xebia://events/%@", self.news.typeId]];
    [[UIApplication sharedApplication] openURL: url];
}

@end