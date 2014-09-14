//
//  XBConferenceCell.m
//  Xebia
//
//  Created by Simone Civetta on 08/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XBConferenceCell.h"

@implementation XBConferenceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 3.0;
}

@end
