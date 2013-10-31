//
// Created by Alexis Kinsella on 21/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "XBAbstractNewsCell.h"

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
    return NO;
}

-(BOOL)customizeBackgroundView {
    return NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, 137);
//    self.imageView.layer.masksToBounds = YES;

    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.titleLabel.text = nil;
}

- (void)updateWithNews:(XBNews *)news {
    self.news = news;
    self.titleLabel.text = news.title;
    self.authorLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Par", nil), news.author];
    NSString *date = [news.publicationDate description];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", date];

//    self.titleView.backgroundColor = [UIColor colorWithHex:@"#000000" alpha:0.50];
//    self.titleLabel.textColor = [UIColor colorWithHex: @"#FFFFFF"];
}

@end