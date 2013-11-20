//
// Created by Alexis Kinsella on 21/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "XBAbstractNewsCell.h"
#import "NSDate+XBAdditions.h"
#import "UIColor+XBAdditions.h"

@interface XBAbstractNewsCell ()

@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong) XBNews *news;

@end

@implementation XBAbstractNewsCell

- (void)configure {

    [super configure];
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (UIColor *)accessoryViewColor {
    return [UIColor darkGrayColor];
}

- (UIColor *)accessoryViewHighlightedColor {
    return [UIColor darkGrayColor];
}

-(UIColor *)accessoryViewBackgroundColor {
    return [UIColor whiteColor];
}

-(BOOL)showSeparatorLine {
    return NO;
}

-(BOOL)customizeSelectedBackgroundView {
    return YES;
}

-(BOOL)customizeBackgroundView {
    return YES;
}

- (UIColor *)gradientLayerColor {
    return [UIColor colorWithHex:@"#444444"];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.titleLabel.text = nil;
    self.excerptImageView.image = nil;
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    return 136;
}

- (void)updateWithNews:(XBNews *)news {
    self.news = news;
    self.titleLabel.text = news.title;
    self.authorLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Par", nil), news.author];
    NSString *date = [news.publicationDate formatDayMonth];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", date];
}

- (void)onSelection {
    NSLog(@"News selected: %@", self.news);
}

@end