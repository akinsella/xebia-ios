//
//  TTTweetCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "TTTweetCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+XBAdditions.h"
#import "UIScreen+XBAdditions.h"
#import "TTHashtagEntity.h"
#import "TTUrlEntity.h"
#import "TTUserMentionEntity.h"
#import "XBConstants.h"

@implementation TTTweetCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10,10,44,44);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3.0;

    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];


    for (TTUserMentionEntity *entity in self.user_mentions) {
        NSRange linkRange = NSMakeRange( [entity.indices.start unsignedIntegerValue], [entity.indices.end unsignedIntegerValue] - [entity.indices.start unsignedIntegerValue] );
        NSString *urlStr = [NSString stringWithFormat:@"http://twitter.com/%@", entity.screen_name];
        NSURL *url = [NSURL URLWithString:urlStr];
        [self.contentLabel addLinkToURL:url withRange:linkRange];
    }
    for (TTHashtagEntity *entity in self.hashtags) {
        NSRange linkRange = NSMakeRange( [entity.indices.start unsignedIntegerValue], [entity.indices.end unsignedIntegerValue] - [entity.indices.start unsignedIntegerValue] );
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/search?q=%%23%@&src=hash", entity.text]];
        [self.contentLabel addLinkToURL:url withRange:linkRange];
    }
    for (TTUrlEntity *entity in self.urls) {
        NSRange linkRange = NSMakeRange( [entity.indices.start unsignedIntegerValue], [entity.indices.end unsignedIntegerValue] - [entity.indices.start unsignedIntegerValue] );
        NSURL *url = [NSURL URLWithString:entity.expanded_url];
        [self.contentLabel addLinkToURL:url withRange:linkRange];
    }
}

- (void)configure {
    self.contentLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    self.contentLabel.textColor = [UIColor colorWithHex:@"#fafafa" alpha:1.0];
    self.contentLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.contentLabel.numberOfLines = 0;

    self.contentLabel.linkAttributes = @{
        (NSString *)kCTForegroundColorAttributeName: (id)[UIColor colorWithHex:@"#72b8f6"].CGColor,
        (NSString *)kCTUnderlineStyleAttributeName: [NSNumber numberWithBool:YES]
    };

    self.contentLabel.activeLinkAttributes = @{
        (NSString *)kCTForegroundColorAttributeName: (id)[UIColor colorWithHex:@"#446F94"].CGColor,
        (NSString *)kCTUnderlineStyleAttributeName: [NSNumber numberWithBool:NO]
    };
}

- (CGFloat)heightForCell {
    CGRect bounds = [UIScreen getScreenBoundsForCurrentOrientation];
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(bounds.size.width - CELL_BORDER_WIDTH, CGFLOAT_MAX)];
    NSLog(@"t: %@ w: %f, h: %f", self.contentLabel.text, size.width, size.height);
    return MAX(CELL_BASE_HEIGHT + size.height, CELL_MIN_HEIGHT);
}

@end