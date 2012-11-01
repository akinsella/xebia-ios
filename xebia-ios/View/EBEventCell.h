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

@interface EBEventCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *descriptionLabel;
@property (nonatomic, strong) IBOutlet UIView *dashedSeparatorView;

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, readonly, strong) UIImage *avatarImage;

+ (CGFloat)heightForCellWithText:(NSString *)text;

@end
