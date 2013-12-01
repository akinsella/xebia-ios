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
#import "DTCustomColoredAccessory.h"
#import "NSDate+XBAdditions.h"

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

    self.descriptionLabel.frame = CGRectMake(
            self.descriptionLabel.frame.origin.x,
            self.descriptionLabel.frame.origin.y,
            self.descriptionLabel.frame.size.width,
            [self descriptionLabelHeight].height
    );
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    CGFloat labelsHeight = self.titleLabelHeight.height + self.descriptionLabelHeight.height;
    CGFloat height = 74 - 21 - 39 + 8 + labelsHeight;
    
    height = MAX(74, height);
    
    return height;
}

- (CGSize)titleLabelHeight {
    return [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.frame.size.width, CGFLOAT_MAX)];
}

- (CGSize)descriptionLabelHeight {
    return [self.descriptionLabel sizeThatFits:CGSizeMake(self.descriptionLabel.frame.size.width, CGFLOAT_MAX)];
}

- (void)updateWithEvent:(EBEvent *)event {

    self.event = event;

    [self.imageView setImage: self.defaultImage];
    self.titleLabel.text = event.title;

    NSString *description = event.descriptionPlainText;

    description = [description stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];

    if ([event.descriptionPlainText length] > 128) {
        description = [NSString stringWithFormat:@"%@ ...",  [description substringToIndex:128]];
    }

    if (event.isCompleted) {
        self.titleLabel.textColor = [[UIColor colorWithHex:@"#fafafa"] darkerColorWithRatio:0.3];
        self.descriptionLabel.textColor = [[UIColor colorWithHex:@"#fafafa"] darkerColorWithRatio:0.3];
        ((DTCustomColoredAccessory *)self.accessoryView).accessoryColor = [self.accessoryViewColor lighterColorWithRatio:0.2];
        ((DTCustomColoredAccessory *)self.accessoryView).highlightedColor = [self.accessoryViewHighlightedColor lighterColorWithRatio:0.2];
    }

    self.descriptionLabel.text = description;
    
    self.dateLabel.text = [NSString stringWithFormat: @"%@", [event.startDate formatDayMonth]];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"Url requested: %@", url);
    [self.appDelegate.mainViewController openURL:url withTitle:@"EventBrite"];
}

@end
