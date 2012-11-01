//
//  GHUserCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "EBEventCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+XBAdditions.h"
#import "UIScreen+XBAdditions.h"

#define FONT_SIZE 13.0f
#define FONT_NAME @"Helvetica"
#define CELL_BORDER_WIDTH 88.0f // 320.0f - 232.0f
#define CELL_MIN_HEIGHT 64.0f
#define CELL_BASE_HEIGHT 48.0f
#define CELL_MAX_HEIGHT 2000.0f

@implementation EBEventCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10,10,44,44);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3.0;
    
    self.dashedSeparatorView.backgroundColor = [UIColor colorWithPatternImageName:@"dashed-separator"];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    [self initContentLabel];
}


- (void)initContentLabel {
    self.descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    self.descriptionLabel.textColor = [UIColor colorWithHex:@"#fafafa" alpha:1.0];
    self.descriptionLabel.lineBreakMode = (NSLineBreakMode) UILineBreakModeTailTruncation;
    self.descriptionLabel.numberOfLines = 0;

    self.descriptionLabel.linkAttributes = @{
        (NSString *)kCTForegroundColorAttributeName: (id)[UIColor colorWithHex:@"#72b8f6"].CGColor,
        (NSString *)kCTUnderlineStyleAttributeName: @YES
    };

    self.descriptionLabel.activeLinkAttributes = @{
        (NSString *)kCTForegroundColorAttributeName: (id)[UIColor colorWithHex:@"#446F94"].CGColor,
        (NSString *)kCTUnderlineStyleAttributeName: @NO
    };

    self.descriptionLabel.dataDetectorTypes = UIDataDetectorTypeLink;

    [self.descriptionLabel setText:self.content];
}

+ (CGFloat)heightForCellWithText:(NSString *)text {
    CGRect bounds = [UIScreen getScreenBoundsForCurrentOrientation];
    NSLog(@"bounds.size.width: %f, CELL_BORDER_WIDTH: %f, CELL_MAX_HEIGHT: %f", bounds.size.width, CELL_BORDER_WIDTH, CELL_MAX_HEIGHT);
    CGSize constraint = CGSizeMake(bounds.size.width - CELL_BORDER_WIDTH, CELL_MAX_HEIGHT);
    CGSize size = [text sizeWithFont:[UIFont fontWithName:FONT_NAME size:FONT_SIZE]
                   constrainedToSize:constraint
                       lineBreakMode:(NSLineBreakMode) UILineBreakModeTailTruncation];
    NSLog(@"size.width: %f,  size.height: %f", size.width, size.height);
    CGFloat height = MAX(CELL_BASE_HEIGHT + size.height, CELL_MIN_HEIGHT);

    return height;
}

@end
