//
//  XBLoadingView.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XBLoadingView.h"

@interface XBLoadingView ()
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation XBLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        self.backgroundColor = [UIColor grayColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.hidesWhenStopped = NO;
        [self.activityIndicator startAnimating];
        [self addSubview:self.activityIndicator];
        self.activityIndicator.center = self.center;
    }
    return self;
}

- (void)dealloc {
    [self.activityIndicator removeFromSuperview];
    [super dealloc];
}

@end
