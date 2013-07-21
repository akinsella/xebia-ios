//
// Created by Alexis Kinsella on 21/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DTCoreText/DTAttributedTextView.h>
#import "XECardDetailsPageViewController.h"

@interface XECardDetailsPageViewController()
@property(nonatomic, strong)XECard *card;
@end

@implementation XECardDetailsPageViewController

- (void)updateWithCard:(XECard *)card {
    self.card = card;
}


@end