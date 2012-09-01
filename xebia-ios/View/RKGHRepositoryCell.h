//
//  RKGHIssueCell.h
//  RKGithub
//
//  Created by Brian Morton on 2/24/12.
//  Copyright (c) 2012 RestKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKGHRepository.h"

@interface RKGHRepositoryCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, readonly, strong) UIImage *avatarImage;

@end
