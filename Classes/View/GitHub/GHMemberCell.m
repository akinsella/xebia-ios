//
// Created by akinsella on 17/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "GHMemberCell.h"
#import <QUartzCore/QuartzCore.h>
#import "UIColor+XBAdditions.h"
#import "UIScreen+XBAdditions.h"
#import "XBConstants.h"

@implementation GHMemberCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10,10,44,44);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3.0;

    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (CGFloat)heightForCell {
    CGRect bounds = [UIScreen getScreenBoundsForCurrentOrientation];
    CGSize size = [self.descriptionLabel sizeThatFits:CGSizeMake(bounds.size.width - CELL_BORDER_WIDTH, CGFLOAT_MAX)];
    return MAX(CELL_BASE_HEIGHT + size.height, CELL_MIN_HEIGHT);
}

@end