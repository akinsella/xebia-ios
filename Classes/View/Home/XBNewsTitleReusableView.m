//
// Created by Alexis Kinsella on 21/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBNewsTitleReusableView.h"
#import "XBNewsViewLayout.h"

@interface XBNewsTitleReusableView ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@end


@implementation XBNewsTitleReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        self.titleLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        self.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        self.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);

        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.titleLabel.text = nil;
}

@end