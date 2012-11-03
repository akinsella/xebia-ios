//
//  UITableViewCell+XBAdditions.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 03/11/12.
//  Copyright (c) 2012 Xebia. All rights reserved.
//

#import "UITableViewCell+XBAdditions.h"
#import "UIScreen+XBAdditions.h"
#import "XBConstants.h"

@implementation UITableViewCell (XBAdditions)


+ (CGFloat)heightForCellWithText:(NSString *)text {
    CGRect bounds = [UIScreen getScreenBoundsForCurrentOrientation];
    NSLog(@"bounds.size.width: %f, CELL_BORDER_WIDTH: %f, CELL_MAX_HEIGHT: %f", bounds.size.width, CELL_BORDER_WIDTH, CGFLOAT_MAX);
    CGSize constraint = CGSizeMake(bounds.size.width - CELL_BORDER_WIDTH, CGFLOAT_MAX);
    CGSize size = [text sizeWithFont:[UIFont fontWithName:FONT_NAME size:FONT_SIZE]
                   constrainedToSize:constraint
                       lineBreakMode:(NSLineBreakMode) UILineBreakModeTailTruncation];
    NSLog(@"size.width: %f,  size.height: %f", size.width, size.height);
    CGFloat height = MAX(CELL_BASE_HEIGHT + size.height, CELL_MIN_HEIGHT);
    
    return height;
}


@end
