//
//  RKWPMenuCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RKWPMenuCell.h"

@implementation RKWPMenuCell
@synthesize titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundView: [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu-cell-bg.png"]]];
        [[self textLabel] setTextColor:[UIColor colorWithRed:0.855 green:0.78 blue:0.863 alpha:1] /*#dac7dc*/];
        [[self textLabel] setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

@end
