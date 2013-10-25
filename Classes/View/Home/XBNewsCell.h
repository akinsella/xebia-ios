//
// Created by Alexis Kinsella on 21/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBNews.h"
#import "XBTableViewCell.h"

@interface XBNewsCell : XBTableViewCell

@property (nonatomic, strong, readonly) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

- (void)updateWithNews:(XBNews *)news;

@end