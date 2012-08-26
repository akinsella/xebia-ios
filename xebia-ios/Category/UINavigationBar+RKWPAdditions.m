//
//  UINavigationBar+RKWPAdditions.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 26/08/12.
//
//

#import "UINavigationBar+RKWPAdditions.h"
#import <objc/runtime.h>

static char const * const BackgroundImageKey = "NavigationBarBackgroundImage";

@implementation UINavigationBar (RKWPAdditions)

@dynamic backgroundImage;

- (UIImage *)backgroundImage {
    return objc_getAssociatedObject(self, BackgroundImageKey);
}

- (void)setBackgroundImage:(UIImage *)newBackgroundImage {
    objc_setAssociatedObject(self, BackgroundImageKey, newBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    // iOS 5.0+ Method
    if ([self respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self setBackgroundImage:newBackgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    
    [self setNeedsDisplay];
}

// If we have a custom background image, then draw it, othwerwise call super and draw the standard nav bar
// iOS 4.0 Method
- (void)drawRect:(CGRect)rect {
    if (self.backgroundImage) {
        [self.backgroundImage drawInRect:rect];
    }
    else {
        [super drawRect:rect];
    }
}

@end
