//
//  RKGHIssueCell.m
//  RKGithub
//
//  Created by Brian Morton on 2/24/12.
//  Copyright (c) 2012 RestKit. All rights reserved.
//

#import "RKGHRepositoryCell.h"
#import "SDImageCache.h"
#import "RKGHRepository.h"

@implementation RKGHRepositoryCell

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


-(void) prepareForReuse {
    identifier = nil;
    avatarImage = nil;
}

@end
