//
//  RKGHIssueCell.m
//  RKGithub
//
//  Created by Brian Morton on 2/24/12.
//  Copyright (c) 2012 RestKit. All rights reserved.
//

#import "RKWPAuthorCell.h"
#import "SDImageCache.h"
#import "RKWPAuthor.h"

@implementation RKWPAuthorCell
@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize bottomDetailLabel;
@synthesize itemCount = _itemCount;
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

- (void)setItemCount:(NSInteger)itemCount {
    _itemCount = itemCount;
    [self updateBottomDetailLabel];
}

- (void)updateBottomDetailLabel {
    self.bottomDetailLabel.text = [NSString stringWithFormat:@"%d posts", self.itemCount];
}

-(void) prepareForReuse {
    identifier = nil;
    avatarImage = nil;
}

@end
