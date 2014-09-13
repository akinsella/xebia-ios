//
//  WPPostTitleCodeElementCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 10/09/13.
//  Copyright (c) 2013 Xebia. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WPPostContentTitleCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+XBAdditions.h"
#import "XBCircleImageView.h"

@interface WPPostContentTitleCell()

@property(nonatomic, strong) WPPost *post;
@property (nonatomic, strong) UIImage* defaultAvatarImage;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet XBCircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end

@implementation WPPostContentTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configure];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configure];
    }
    
    return self;
}

- (void)configure {
    self.defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder"];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.accessoryType = UITableViewCellAccessoryNone;

    self.avatarImageView.backgroundColor = [UIColor clearColor];
    self.avatarImageView.defaultImage = self.defaultAvatarImage;
    self.avatarImageView.offset = 2;
    self.avatarImageView.backgroundImage = [UIImage imageNamed:@"dp_holder_large"];
}

-(void)updateWithWPPost:(WPPost *)post {
    self.post = post;
    WPAuthor *author = post.authors[0];

    self.tagLabel.text = post.tagsFormatted;
    self.categoryLabel.text = post.categoriesFormatted;
    self.titleLabel.text = post.titlePlain;
    self.authorLabel.text = [NSString stringWithFormat: @"%@ %@", NSLocalizedString(@"By", nil), [author.name uppercaseString]];
    self.dateLabel.text = [NSString stringWithFormat: @"%@", [post.date formatDayLongMonth]];

    [[SDWebImageManager sharedManager] downloadImageWithURL:author.avatarImageUrl
                                               options:(SDWebImageOptions) kNilOptions
                                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                 if ((error || !image) && self.post == post) {
                                                     self.avatarImageView.image = self.defaultAvatarImage;
                                                 }
                                                 else if (self.post == post) {
                                                     self.avatarImageView.image = image;
                                                 }
                                             }];

}

- (CGFloat)heightForCell:(UITableView *)tableView {
    return 142;
}


@end