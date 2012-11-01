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

@interface TTTweetCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *authorNameLabel;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UIView *dashedSeparatorView;

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) TTEntities *entities;
@property (nonatomic, readonly, strong) UIImage *avatarImage;

+ (CGFloat)heightForCellWithText:(NSString *)text;

@end
