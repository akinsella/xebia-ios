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
    self.avatarImageView.backgroundImage = [UIImage imageNamed:@"dp_holder_large.png"];
}

-(void)updateWithWPPost:(WPPost *)post {
    self.post = post;
    WPAuthor *author = post.authors[0];

    self.tagLabel.text = post.tagsFormatted;
    self.categoryLabel.text = post.categoriesFormatted;
    self.titleLabel.text = post.titlePlain;
    self.authorLabel.text = [NSString stringWithFormat: NSLocalizedString(@"Par %@", nil), [author.name uppercaseString]];
    self.dateLabel.text = [NSString stringWithFormat: NSLocalizedString(@"Le %@", nil), [post.date formatDayLongMonth]];

    [[SDWebImageManager sharedManager] downloadWithURL:author.avatarImageUrl delegate:self options:kNilOptions
            success:^(UIImage *image) {
                self.avatarImageView.image = image;
            }
            failure:^(NSError *error) {
                self.avatarImageView.image = self.defaultAvatarImage;
            }];
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    return 142;
}


@end