//
//  WPTagCell.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 26/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBTableViewCell.h"

@interface WPTagCell : XBTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *bottomDetailLabel;

@property (nonatomic, assign) NSInteger itemCount;

@end