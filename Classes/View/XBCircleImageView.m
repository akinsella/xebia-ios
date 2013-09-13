//
//  XBCircleImageView.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 11/09/13.
//  Copyright (c) 2013 Xebia. All rights reserved.
//

#import "XBCircleImageView.h"

@implementation XBCircleImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self setNeedsDisplay];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    [self setNeedsDisplay];
}

- (void)setDefaultImage:(UIImage *)defaultImage {
    _defaultImage = defaultImage;
    [self setNeedsDisplay];
}

- (void)setOffset:(CGFloat) offset {
    _offset = offset;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //Drawing the background image.
    [self.backgroundImage drawInRect: self.bounds];

    //Drawing the user image in rounded shape.
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSaveGState( context );

    CGRect clipRect = CGRectMake(
        self.offset,
        self.offset,
        self.frame.size.width - self.offset * 2,
        self.frame.size.height - self.offset * 2
    );

    CGContextAddEllipseInRect(context, clipRect);

    CGContextClip(context);

    CGContextClearRect(context, clipRect);

    if (self.image) {
        [self.image drawInRect : CGRectMake(clipRect.origin.x, clipRect.origin.y, clipRect.size.width, clipRect.size.height)];
    }
    else {
        [self.defaultImage drawInRect : CGRectMake(clipRect.origin.x, clipRect.origin.y, clipRect.size.width, clipRect.size.height)];
    }

    CGContextRestoreGState(context);
}

@end
