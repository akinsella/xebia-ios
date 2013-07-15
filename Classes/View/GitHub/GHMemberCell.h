//
// Created by akinsella on 17/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBTableViewCell.h"
#import "GHMember.h"

@interface GHMemberCell : XBTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property(nonatomic, strong, readonly) GHMember *member;

- (CGFloat)heightForCell;

- (void)updateWithMember:(GHMember *)member;

@end