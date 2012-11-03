//
//  XBMenuCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 26/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "XBMenuCell.h"

@implementation XBMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0]];
        [self.textLabel setTextColor: [UIColor whiteColor]];
        [self.textLabel setShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75]];
        [self.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];

        
        UIImage *backgroundImage = [[UIImage imageNamed:@"LightBackground.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:1];
        self.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView.frame = self.bounds;
        self.backgroundView.alpha = 0.8;
    }
    return self;
}

@end
