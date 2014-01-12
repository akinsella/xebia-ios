//
//  XBConferenceHomeMenuItemCell.h
//  Xebia
//
//  Created by Simone Civetta on 12/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBTableViewCell.h"

@class NSString;

@interface XBConferenceHomeMenuItemCell : XBTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

- (void)configureWithTitle:(NSString *)title;
@end
