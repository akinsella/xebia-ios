//
//  GHRepositoryCell.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHRepositoryCell.h"
#import "XBTableViewCell.h"
#import "GHRepository.h"

@interface GHRepositoryCell : XBTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, readonly, strong) UIImage *avatarImage;

- (CGFloat)heightForCell;

- (void)updateWithRepository:(GHRepository *)repository defaultImage:(UIImage *)image;
@end
