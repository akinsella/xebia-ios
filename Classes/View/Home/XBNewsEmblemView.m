//
// Created by Alexis Kinsella on 21/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBNewsEmblemView.h"

static NSString * const BHEmblemViewImageName = @"emblem";

@implementation XBNewsEmblemView

+ (CGSize)defaultSize {
    return [UIImage imageNamed:BHEmblemViewImageName].size;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:BHEmblemViewImageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = self.bounds;

        [self addSubview:imageView];
    }
    return self;
}

@end