//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBTableViewCell.h"
#import "XEAbstractCell.h"

@class XECard;


@interface XECardCell : XEAbstractCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) NSNumber *identifier;

@property(nonatomic, strong) XECard *card;

- (void)updateWithCard:(XECard *)card;

@end