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

- (void)setItemCount:(NSInteger)itemCount {
    _itemCount = itemCount;
    [self updateBottomDetailLabel];
}


- (void)updateBottomDetailLabel {
    self.bottomDetailLabel.text = [NSString stringWithFormat:@"%ld posts", self.itemCount];
}

-(void) prepareForReuse {
    identifier = nil;
    avatarImage = nil;
}

-(void)loadAvatarFromAuthor:(RKWPAuthor *)author defaultAvatar:(UIImage *)defaultAvatarImage {
    NSString *avatarImageUrl = [[author avatarImageUrl] absoluteString];
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromKey:avatarImageUrl];
    if (cachedImage) {
        [[self imageView] setImage: cachedImage];
    }
    else {
        [[self imageView] setImage: defaultAvatarImage];
        NSLog(@"Download image: %@", [author avatarImageUrl]);
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:author.avatarImageUrl
                        delegate:self
                         options:0
                         success:^(UIImage *image) {
                             [[SDImageCache sharedImageCache] storeImage:image forKey:avatarImageUrl];
                             if ([[self identifier] intValue]== [[author identifier] intValue]) {
                                 [[self imageView] setImage: image];   
                             }
                             else {
                                 NSLog(@"Not loading image for author[%@]: Different from current cell id: [%@]", [author identifier], [self identifier] );
                             }
                         }
                         failure:^(NSError *error) {
                             [[SDImageCache sharedImageCache] storeImage:defaultAvatarImage forKey:avatarImageUrl];
                             if ([[self identifier] intValue]== [[author identifier] intValue]) {
                                 [[self imageView] setImage: defaultAvatarImage];
                             }
                             else {
                                 NSLog(@"Not loading image for author[%@]: Different from current cell id: [%@]", [author identifier], [self identifier] );
                             }
                         }];
    }

}

@end
