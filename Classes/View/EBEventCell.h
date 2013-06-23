//
//  GHUserCell.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBEvent.h"
#import "TTTAttributedLabel.h"
#import "XBTableViewCell.h"

static CGFloat const MAX_CELL_HEIGHT = 240.0;

@interface EBEventCell : XBTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *descriptionLabel;

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, readonly, strong) UIImage *avatarImage;

- (void)configure;
- (CGFloat)heightForCell;

@end
