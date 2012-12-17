//
// Created by akinsella on 17/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface GHOwnerCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) IBOutlet UIView *dashedSeparatorView;

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, readonly, strong) UIImage *avatarImage;

- (CGFloat)heightForCell;

@end