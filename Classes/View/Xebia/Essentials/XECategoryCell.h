//
// Created by Alexis Kinsella on 11/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBTableViewCell.h"

@interface XECategoryCell : XBTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

- (void)configure;

@end