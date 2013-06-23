//
// Created by akinsella on 17/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBTableViewCell.h"

@interface GHMemberCell : XBTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, readonly, strong) UIImage *avatarImage;

- (CGFloat)heightForCell;

@end