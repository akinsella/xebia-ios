//
//  GHRepositoryCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "GHRepositoryCell.h"
#import "QuartzCore/QuartzCore.h"
#import "UIColor+XBAdditions.h"
#import "UIScreen+XBAdditions.h"
#import "XBConstants.h"

@implementation GHRepositoryCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10,9,44,44);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3.0;
    
    self.dashedSeparatorView.backgroundColor = [UIColor colorWithPatternImageName:@"dashed-separator"];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (CGFloat)heightForCell {
    CGRect bounds = [UIScreen getScreenBoundsForCurrentOrientation];
    CGSize size = [self.descriptionLabel sizeThatFits:CGSizeMake(bounds.size.width - CELL_BORDER_WIDTH, CGFLOAT_MAX)];
    return MAX(CELL_BASE_HEIGHT + size.height, CELL_MIN_HEIGHT);
}

@end
