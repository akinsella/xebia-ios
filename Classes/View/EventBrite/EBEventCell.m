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
#import "UIScreen+XBAdditions.h"
#import "XBMainViewController.h"

@interface EBEventCell ()
@property (nonatomic, strong) UIImage*defaultImage;
@property(nonatomic, strong) EBEvent *event;
@end

@implementation EBEventCell

- (void)configure {

    [super configure];

    self.defaultImage = [UIImage imageNamed:@"eventbrite"];

    self.descriptionLabel.delegate = self;

    self.descriptionLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    self.descriptionLabel.textColor = [UIColor colorWithHex:@"#fafafa" alpha:1.0];
    self.descriptionLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.descriptionLabel.numberOfLines = 0;

    self.descriptionLabel.linkAttributes = @{
            (NSString *)kCTForegroundColorAttributeName: (id)[UIColor colorWithHex:@"#72b8f6"].CGColor,
            (NSString *)kCTUnderlineStyleAttributeName: [NSNumber numberWithBool:YES]
    };

    self.descriptionLabel.activeLinkAttributes = @{
            (NSString *)kCTForegroundColorAttributeName: (id)[UIColor colorWithHex:@"#446F94"].CGColor,
            (NSString *)kCTUnderlineStyleAttributeName: [NSNumber numberWithBool:NO]
    };

    self.descriptionLabel.dataDetectorTypes = UIDataDetectorTypeLink;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10,10,44,44);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3.0;
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    CGRect bounds = [UIScreen getScreenBoundsForCurrentOrientation];
    CGSize size = [self.descriptionLabel sizeThatFits:CGSizeMake(bounds.size.width - CELL_BORDER_WIDTH, CGFLOAT_MAX)];
    CGFloat computedHeight = MAX(CELL_BASE_HEIGHT + size.height, CELL_MIN_HEIGHT);
    return MIN(computedHeight, MAX_CELL_HEIGHT);
}

- (void)updateWithEvent:(EBEvent *)event {

    self.event = event;

    [self.imageView setImage: self.defaultImage];
    self.titleLabel.text = event.title;

    NSString *description = event.description_plain_text;

    description = [description stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];

    if ([event.description_plain_text length] > 128) {
        description = [NSString stringWithFormat:@"%@ ...",  [description substringToIndex:128]];
    }

    self.descriptionLabel.text = description;

}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"Url requested: %@", url);
    [self.appDelegate.mainViewController openURL:url withTitle:@"EventBrite"];
}

@end
