//
//  UINavigationBar+XBAdditions.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 26/08/12.
//
//

#import "UINavigationBar+XBAdditions.h"
#import <objc/runtime.h>

static char const * const BackgroundImageKey = "NavigationBarBackgroundImage";

@implementation UINavigationBar (XBAdditions)

@dynamic backgroundImage;

- (UIImage *)backgroundImage {
    return objc_getAssociatedObject(self, BackgroundImageKey);
}

// With a custom back button, we have to provide the action. We simply pop the view controller
- (IBAction)back:(id)sender
{
    
//    [self. popViewControllerAnimated:YES];
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


// Given the prpoer images and cap width, create a variable width back button
-(UIButton*) backButtonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)backButtonCapWidth target:(id)target action:(SEL)actionSelector text: (NSString *)text
{
    // Create stretchable images for the normal and highlighted states
    UIImage* buttonImage = [backButtonImage stretchableImageWithLeftCapWidth:backButtonCapWidth topCapHeight:0.0];
    UIImage* buttonHighlightImage = [backButtonHighlightImage stretchableImageWithLeftCapWidth:backButtonCapWidth topCapHeight:0.0];
    
    // Create a custom button
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Set the title to use the same font and shadow as the standard back button
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    // Set the break mode to truncate at the end like the standard back button
    button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    // Inset the title on the left and right
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 6.0, 0, 3.0);
    
    // Make the button as high as the passed in image
    button.frame = CGRectMake(0, 0, 0, buttonImage.size.height);
    
    // Just like the standard back button, use the title of the previous item as the default back text
    [self setText:text onBackButton:button leftCapWidth:backButtonCapWidth];
    
    // Set the stretchable images as the background for the button
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateSelected];
    
    // Add an action for going back
    [button addTarget:target action:actionSelector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

// Set the text on the custom back button
-(void) setText:(NSString*)text onBackButton:(UIButton*)backButton leftCapWidth:(CGFloat)backButtonCapWidth {
    // Measure the width of the text
    CGSize textSize = [text sizeWithFont:backButton.titleLabel.font];
    // Change the button's frame. The width is either the width of the new text or the max width
    backButton.frame = CGRectMake(backButton.frame.origin.x, backButton.frame.origin.y, (textSize.width + (backButtonCapWidth * 1.5)) > MAX_BACK_BUTTON_WIDTH ? MAX_BACK_BUTTON_WIDTH : (textSize.width + (backButtonCapWidth * 1.5)), backButton.frame.size.height);
    
    // Set the text on the button
    [backButton setTitle:text forState:UIControlStateNormal];
}


// Given the prpoer images and cap width, create a variable width back button
-(UIButton*) backButtonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage target:(id)target action:(SEL)actionSelector {

    // Create a custom button
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];

    // Make the button as high as the passed in image
    button.frame = CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height);

    // Set the stretchable images as the background for the button
    [button setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [button setBackgroundImage:backButtonHighlightImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:backButtonHighlightImage forState:UIControlStateSelected];
    
    // Add an action for going back
    [button addTarget:target action:actionSelector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end
