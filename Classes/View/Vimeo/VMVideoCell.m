//
// Created by Alexis Kinsella on 23/06/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "VMVideoCell.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+XBAdditions.h"
#import "XBConstants.h"
#import "VMThumbnail.h"
#import "NSDate+XBAdditions.h"


@interface VMVideoCell ()
@property(nonatomic, strong) VMVideo *video;
@property (nonatomic, strong) UIImage* defaultAvatarImage;
@end

@implementation VMVideoCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0,0,100,75);
    self.imageView.layer.masksToBounds = YES;
}

- (void)configure {

    [super configure];

    self.defaultAvatarImage = [UIImage imageNamed:@"video_placeholder_small"];

    self.descriptionLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    self.descriptionLabel.textColor = [UIColor colorWithHex:@"#fafafa" alpha:1.0];
    self.descriptionLabel.lineBreakMode = (NSLineBreakMode)UILineBreakModeTailTruncation;
    self.descriptionLabel.numberOfLines = 0;
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    return 75;
}

- (void)updateWithVideo:(VMVideo *)video {
    self.video = video;
    VMThumbnail *thumbnail = video.thumbnails[0];
    NSURL* thumbnailUrl = [NSURL URLWithString:[thumbnail url]];
    [self.imageView setImageWithURL:thumbnailUrl placeholderImage:self.defaultAvatarImage];

    self.titleLabel.text = video.title;
    self.dateLabel.text = [NSString stringWithFormat: @"%@", [video.uploadDate formatAuto]];
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@%@ %@", video.isHd ? @"HD | ": @"", video.playCount, NSLocalizedString(@"read(s)", nil)];
}

@end