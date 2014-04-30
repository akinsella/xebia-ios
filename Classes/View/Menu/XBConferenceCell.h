//
//  XBConferenceCell.h
//  Xebia
//
//  Created by Simone Civetta on 08/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBTableViewCell.h"

@interface XBConferenceCell : XBTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;

@end
