//
//  XBConferenceCell.m
//  Xebia
//
//  Created by Simone Civetta on 08/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceCell.h"
#import "UIColor+XBAdditions.h"

@implementation XBConferenceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIColor *)customizedBackgroundColor {
    return [UIColor colorWithHex:@"#222222"];
}

@end
