//
//  GHIssueCell.m
//  RKGithub
//
//  Created by Brian Morton on 2/24/12.
//  Copyright (c) 2012 RestKit. All rights reserved.
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
