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

@interface TTTweetCell : XBTableViewCell<TTTAttributedLabelDelegate>

@property (nonatomic, strong) IBOutlet UILabel *authorNameLabel;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property(nonatomic, strong, readonly) TTTweet *tweet;

- (CGFloat)heightForCell: (UITableView *)tableView;

- (void)updateWithTweet:(TTTweet *)tweet;

@end
