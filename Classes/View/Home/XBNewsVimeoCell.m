//
// Created by Alexis Kinsella on 21/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "XBNewsVimeoCell.h"

@implementation XBNewsVimeoCell

- (void)onSelection {
    [super onSelection];
//    [self.appDelegate.mainViewController revealViewControllerWithIdentifier:@"videos"];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"xebia://videos/%@", self.news.identifier]];
    [[UIApplication sharedApplication] openURL: url];
}

@end