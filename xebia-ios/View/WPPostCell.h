//
//  WPPostCell.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPPost.h"

@interface WPPostCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *commentLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *tagsLabel;
@property (nonatomic, strong) IBOutlet UILabel *categoriesLabel;
@property (nonatomic, strong) IBOutlet UILabel *authorLabel;
@property (nonatomic, strong) IBOutlet UIView *dashedSeparatorView;

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, readonly, strong) UIImage *postImage;

@end
