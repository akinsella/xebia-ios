//
//  WPCategoryCell.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBTableViewCell.h"
#import "WPCategory.h"

@interface WPCategoryCell : XBTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *bottomDetailLabel;
@property(nonatomic, strong, readonly) WPCategory *category;

- (void)updateWithCategory:(WPCategory *)category;
@end
