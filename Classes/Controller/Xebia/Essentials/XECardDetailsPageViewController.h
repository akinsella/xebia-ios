//
// Created by Alexis Kinsella on 21/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XECard.h"

@interface XECardDetailsPageViewController : UIViewController
@property(nonatomic, strong, readonly)XECard *card;

- (void)updateWithCard:(XECard *)card;

@end