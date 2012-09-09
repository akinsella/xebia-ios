//
//  XBMenuCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XBMenuCell.h"

@implementation XBMenuCell

@synthesize titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self setBackgroundView: [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu-cell-bg.png"]]];
//        [self.textLabel setTextColor:[UIColor whiteColor] /*#dac7dc*/];
//        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0]];
        [self.textLabel setTextColor: [UIColor whiteColor]];
        [self.textLabel setShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75]];
        [self.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];

        
        UIImage *backgroundImage = [[UIImage imageNamed:@"LightBackground.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
        self.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView.frame = self.bounds;
        self.backgroundView.alpha = 0.8;
    }
    return self;
}

@end
