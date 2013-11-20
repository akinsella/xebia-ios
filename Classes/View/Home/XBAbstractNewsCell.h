//
// Created by Alexis Kinsella on 21/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBNews.h"
#import "XBTableViewCell.h"

@class XBNewsMetadata;

@interface XBAbstractNewsCell : XBTableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *excerptImageView;

@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UILabel *authorLabel;

@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong, readonly) XBNews *news;

- (void)updateWithNews:(XBNews *)news;

- (void)onSelection;

@end