//
//  TTTweetCell.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTweet.h"
#import "TTTAttributedLabel.h"
#import "XBTableViewCell.h"

@interface TTTweetCell : XBTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *authorNameLabel;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, readonly, strong) UIImage *avatarImage;

@property (nonatomic, strong) NSArray *hashtags;
@property (nonatomic, strong) NSArray *urls;
@property (nonatomic, strong) NSArray *user_mentions;


- (void)configure;

- (CGFloat)heightForCell;

@end
