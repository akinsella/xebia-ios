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

- (BOOL)showSeparatorLine {
    return NO;
}

- (BOOL)showSelectedSeparatorLine {
    return NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10,10,22,22);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3.0;
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0]];
    [self.textLabel setTextColor: [UIColor whiteColor]];
    [self.textLabel setShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75]];
    [self.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
}

@end
