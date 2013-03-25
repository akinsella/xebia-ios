//
//  WPSPostCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPSPostCell.h"
#import "SDImageCache.h"
#import "WPPost.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+XBAdditions.h"

@implementation WPSPostCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WPSPostCell"]];
        self.selectedBackgroundView.backgroundColor=[UIColor blackColor];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ( !(self = [super initWithCoder:aDecoder]) ) return nil;

    // Your code goes here!

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(9,26,44,44);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3.0;

    self.dashedSeparatorView.backgroundColor = [UIColor colorWithPatternImageName:@"dashed-separator"];
}

@end