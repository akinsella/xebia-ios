//
// Created by Alexis Kinsella on 21/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "XBNewsTwitterCell.h"

@implementation XBNewsTwitterCell


- (CGFloat)heightForCell:(UITableView *)tableView {
    return 70;
}

- (void)updateWithNews:(XBNews *)news {
    [super updateWithNews:news];
    [self.titleLabel sizeToFit];
}

- (void)onSelection {
    [super onSelection];
//    [self.appDelegate.mainViewController revealViewControllerWithIdentifier:@"tweets"];

    NSURL * url  = [NSURL URLWithString:[NSString stringWithFormat: @"xebia://tweets/%@", self.news.typeId]];
    [[UIApplication sharedApplication] openURL: url];

}

@end