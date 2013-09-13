//
//  WPSPostCell.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPPost.h"
#import "XBTableViewCell.h"
#import "XBCircleImageView.h"

@interface WPSPostCell : XBTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *categoriesLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorLabel;
@property (nonatomic, weak) IBOutlet XBCircleImageView *avatarImageView;

@property(nonatomic, strong, readonly) WPPost *post;

- (void)updateWithPost:(WPPost *)post;

@end
