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

#define FONT_SIZE 13.0f
#define FONT_NAME @"Helvetica"
#define CELL_BORDER_WIDTH 88.0f // 320.0f - 232.0f
#define CELL_MIN_HEIGHT 64.0f
#define CELL_BASE_HEIGHT 28.0f
#define CELL_MAX_HEIGHT 1000.0f

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

+ (CGFloat)heightForCellWithText:(NSString *)text {
    CGRect bounds = [UIScreen getScreenBoundsForCurrentOrientation];
    CGSize constraint = CGSizeMake(bounds.size.width - CELL_BORDER_WIDTH, CELL_MAX_HEIGHT);
    CGSize size = [text sizeWithFont:[UIFont fontWithName:FONT_NAME size:FONT_SIZE]
                   constrainedToSize:constraint
                       lineBreakMode:(NSLineBreakMode) UILineBreakModeTailTruncation];
    CGFloat height = MAX(CELL_BASE_HEIGHT + size.height, CELL_MIN_HEIGHT);
    return height;
}

@end
