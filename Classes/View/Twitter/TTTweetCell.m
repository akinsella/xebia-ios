//
//  TTTweetCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "TTTweetCell.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+XBAdditions.h"
#import "UIScreen+XBAdditions.h"
#import "TTHashtagEntity.h"
#import "TTUrlEntity.h"
#import "TTUserMentionEntity.h"
#import "XBConstants.h"
#import "NSDate+XBAdditions.h"

@interface TTTweetCell ()

@property (nonatomic, strong) UIImage* defaultAvatarImage;
@property (nonatomic, strong) UIImage* xebiaAvatarImage;
@property(nonatomic, strong) TTTweet *tweet;

@end

@implementation TTTweetCell

- (void)configure {

    [super configure];

    self.defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder"];
    self.xebiaAvatarImage = [UIImage imageNamed:@"xebia-avatar"];

    self.contentLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    self.contentLabel.textColor = [UIColor colorWithHex:@"#444444" alpha:1.0];
    self.contentLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.contentLabel.numberOfLines = 0;

    self.contentLabel.linkAttributes = @{
            (NSString *)kCTForegroundColorAttributeName: (id)[UIColor colorWithHex:@"#666666"].CGColor,
            (NSString *)kCTUnderlineStyleAttributeName: [NSNumber numberWithBool:YES]
    };

    self.contentLabel.activeLinkAttributes = @{
            (NSString *)kCTForegroundColorAttributeName: (id)[UIColor colorWithHex:@"#222222"].CGColor,
            (NSString *)kCTUnderlineStyleAttributeName: [NSNumber numberWithBool:NO]
    };
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10,10,44,44);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3.0;

    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    XBLog("Default - %@", self.avatarImageView.image);
    self.avatarImageView.offset = 2;
    self.avatarImageView.backgroundColor = [UIColor clearColor];
    self.avatarImageView.backgroundImage = [UIImage imageNamed:@"dp_holder_large"];
    self.avatarImageView.defaultImage = self.defaultAvatarImage;


    for (TTUserMentionEntity *entity in self.tweet.entities.user_mentions) {
        NSRange linkRange = NSMakeRange( [entity.indices.start unsignedIntegerValue], [entity.indices.end unsignedIntegerValue] - [entity.indices.start unsignedIntegerValue] );
        NSString *urlStr = [NSString stringWithFormat:@"http://mobile.twitter.com/%@", entity.screen_name];
        NSURL *url = [NSURL URLWithString:urlStr];
        [self.contentLabel addLinkToURL:url withRange:linkRange];
    }
    for (TTHashtagEntity *entity in self.tweet.entities.hashtags) {
        NSRange linkRange = NSMakeRange( [entity.indices.start unsignedIntegerValue], [entity.indices.end unsignedIntegerValue] - [entity.indices.start unsignedIntegerValue] );
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://mobile.twitter.com/search?q=%%23%@", entity.text]];
        [self.contentLabel addLinkToURL:url withRange:linkRange];
    }
    for (TTUrlEntity *entity in self.tweet.entities.urls) {
        NSRange linkRange = NSMakeRange( [entity.indices.start unsignedIntegerValue], [entity.indices.end unsignedIntegerValue] - [entity.indices.start unsignedIntegerValue] );
        NSURL *url = [NSURL URLWithString:entity.expanded_url];
        [self.contentLabel addLinkToURL:url withRange:linkRange];
    }
}

- (CGFloat)heightForCell: (UITableView *)tableView {
    CGRect bounds = [UIScreen getScreenBoundsForCurrentOrientation];
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(bounds.size.width - CELL_BORDER_WIDTH, CGFLOAT_MAX)];
    NSLog(@"t: %@ w: %f, h: %f", self.contentLabel.text, size.width, size.height);
    return MAX(CELL_BASE_HEIGHT + size.height, CELL_MIN_HEIGHT);
}

- (void)updateWithTweet:(TTTweet *)tweet {

    self.tweet = tweet;
    
    [self configure];
    
    self.contentLabel.delegate = self;
    if ([tweet.ownerScreenName isEqualToString:@"XebiaFr"]) {
        self.avatarImageView.image = self.xebiaAvatarImage;
    }
    else {
        [[SDWebImageManager sharedManager] downloadWithURL:tweet.ownerImageUrl
                                                   options:kNilOptions
                                                  progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                     if (error || !image) {
                                                         XBLog("Error - %@ for: %@", error, tweet.ownerScreenName);
                                                         self.avatarImageView.image = self.defaultAvatarImage;
                                                     }
                                                     else {
                                                         XBLog("Success - %@ for: %@", image, tweet.ownerScreenName);
                                                         self.avatarImageView.image = image;
                                                     }
                                                 }];
    }




    self.authorNameLabel.text = tweet.ownerScreenName;
    self.dateLabel.text = [NSString stringWithFormat:@"%@",
                            [tweet.created_at isToday] ? [tweet.created_at formatTime] : [tweet.created_at formatDayMonth]];
    self.contentLabel.text = tweet.text;
}


- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"Url requested: %@", url);
    [self.appDelegate.mainViewController openURL:url withTitle:@"Twitter"];
}

@end
