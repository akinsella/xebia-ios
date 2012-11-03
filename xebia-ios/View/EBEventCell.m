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
#import "XBConstants.h"

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
    self.descriptionLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
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

@end
