//
//  GHIssueCell.m
//  RKGithub
//
//  Created by Brian Morton on 2/24/12.
//  Copyright (c) 2012 RestKit. All rights reserved.
//

#import "WPAuthorCell.h"
#import "SDImageCache.h"
#import "WPAuthor.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+XBAdditions.h"

@implementation WPAuthorCell

@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize bottomDetailLabel;
@synthesize itemCount = _itemCount;
@synthesize identifier;
@synthesize avatarImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // set selection color
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(8,7,44,44);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3.0;
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
