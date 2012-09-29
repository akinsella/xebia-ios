//
//  TTTweetCell.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTweet.h"

@interface TTTweetCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *authorNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *nicknameLabel;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, readonly, strong) UIImage *avatarImage;

@end
