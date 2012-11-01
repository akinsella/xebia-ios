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
#import "TTEntity.h"
#import "UIScreen+XBAdditions.h"
#import "TTHashtagEntity.h"
#import "TTUrlEntity.h"
#import "TTUserMentionEntity.h"
#import "UIColor+XBAdditions.h"

#define FONT_SIZE 13.0f
#define FONT_NAME @"Helvetica"
#define CELL_BORDER_WIDTH 88.0f // 320.0f - 232.0f
#define CELL_MIN_HEIGHT 64.0f
#define CELL_BASE_HEIGHT 48.0f
#define CELL_MAX_HEIGHT 1000.0f

@implementation TTTweetCell


- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10,10,44,44);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3.0;
    
    self.dashedSeparatorView.backgroundColor = [UIColor colorWithPatternImageName:@"dashed-separator"];

    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    [self initContentLabel];
}

- (void)initContentLabel {
    self.contentLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    self.contentLabel.textColor = [UIColor colorWithHex:@"#fafafa" alpha:1.0];
    self.contentLabel.lineBreakMode = (NSLineBreakMode) UILineBreakModeTailTruncation;
    self.contentLabel.numberOfLines = 0;

    self.contentLabel.linkAttributes = @{
        (NSString *)kCTForegroundColorAttributeName: (id)[UIColor colorWithHex:@"#72b8f6"].CGColor,
        (NSString *)kCTUnderlineStyleAttributeName: @YES
    };

    self.contentLabel.activeLinkAttributes = @{
        (NSString *)kCTForegroundColorAttributeName: (id)[UIColor colorWithHex:@"#446F94"].CGColor,
        (NSString *)kCTUnderlineStyleAttributeName: @NO
    };

    [[self contentLabel] setText: self.content];

    for (TTUserMentionEntity *entity in _entities.user_mentions) {
        NSRange linkRange = NSMakeRange( [entity.indices[0] unsignedIntegerValue], [entity.indices[1] unsignedIntegerValue] - [entity.indices[0] unsignedIntegerValue] );
        NSString *urlStr = [NSString stringWithFormat:@"http://twitter.com/%@", entity.screen_name];
        NSURL *url = [NSURL URLWithString:urlStr];
        [self.contentLabel addLinkToURL:url withRange:linkRange];
    }
    for (TTHashtagEntity *entity in _entities.hashtags) {
        NSRange linkRange = NSMakeRange( [entity.indices[0] unsignedIntegerValue], [entity.indices[1] unsignedIntegerValue] - [entity.indices[0] unsignedIntegerValue] );
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/search?q=%%23%@&src=hash", entity.text]];
        [self.contentLabel addLinkToURL:url withRange:linkRange];
    }
    for (TTUrlEntity *entity in _entities.urls) {
        NSRange linkRange = NSMakeRange( [entity.indices[0] unsignedIntegerValue], [entity.indices[1] unsignedIntegerValue] - [entity.indices[0] unsignedIntegerValue] );
        NSURL *url = [NSURL URLWithString:entity.expanded_url];
        [self.contentLabel addLinkToURL:url withRange:linkRange];
    }

}

- (void)dealloc {
    [_contentLabel release];
    [super dealloc];
}

+ (CGFloat)heightForCellWithText:(NSString *)text {
    CGRect bounds = [UIScreen getScreenBoundsForCurrentOrientation];
    CGSize constraint = CGSizeMake(bounds.size.width - CELL_BORDER_WIDTH, CELL_MAX_HEIGHT);
    CGSize size = [text sizeWithFont:[UIFont fontWithName:FONT_NAME size:FONT_SIZE]
                   constrainedToSize:constraint
                       lineBreakMode:(NSLineBreakMode) UILineBreakModeTailTruncation];
    CGFloat height = MAX(CELL_BASE_HEIGHT + size.height, CELL_MIN_HEIGHT);

    return height;
}

@end
