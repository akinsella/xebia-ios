//
// Created by Alexis Kinsella on 21/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "XBNewsEventBriteCell.h"

@implementation XBNewsEventBriteCell

- (void)updateWithNews:(XBNews *)news {
    [super updateWithNews:news];
    [self.titleLabel sizeToFit];
}

- (void)onSelection {
    [super onSelection];
//    [self.appDelegate.mainViewController revealViewControllerWithIdentifier:@"events"];

    NSURL * url  = [NSURL URLWithString:[NSString stringWithFormat: @"xebia://events/%@", self.news.identifier]];
    [[UIApplication sharedApplication] openURL: url];
}

@end