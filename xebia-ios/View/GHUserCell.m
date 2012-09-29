//
//  GHUserCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "GHUserCell.h"
#import "SDImageCache.h"
#import "GHUser.h"

@implementation GHUserCell

@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize identifier;
@synthesize avatarImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0,0,44,44);
}

-(void) prepareForReuse {
    identifier = nil;
    avatarImage = nil;
}

@end
