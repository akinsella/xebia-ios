//
// Created by Alexis Kinsella on 11/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBTableViewCell.h"
#import "XECategory.h"
#import "XEAbstractCell.h"

@interface XECategoryCell : XEAbstractCell

@property (nonatomic, strong) XECategory *category;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

- (void)updateWithCategory:(XECategory *)category;
@end