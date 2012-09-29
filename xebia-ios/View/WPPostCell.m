//
//  WPPostCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPPostCell.h"
#import "SDImageCache.h"
#import "WPPost.h"

@implementation WPPostCell

@synthesize titleLabel;
@synthesize excerptLabel;
@synthesize tagsLabel;
@synthesize categoriesLabel;
@synthesize authorLabel;
@synthesize identifier;
@synthesize postImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [ [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WPPostCell"]] autorelease];
        self.selectedBackgroundView.backgroundColor=[UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(9,113,64,64);
}

-(void) prepareForReuse {
    identifier = nil;
    postImage = nil;
}

@end
