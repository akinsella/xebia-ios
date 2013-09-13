//
//  WPAuthorCell.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPAuthor.h"
#import "XBTableViewCell.h"
#import "XBCircleImageView.h"

@interface WPAuthorCell : XBTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet XBCircleImageView *avatarImageView;

@property (nonatomic, strong, readonly) WPAuthor *author;

- (void)updateWithAuthor:(WPAuthor *)author;

@end
