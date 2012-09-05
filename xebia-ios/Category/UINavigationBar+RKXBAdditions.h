//
//  UINavigationBar+RKXBAdditions.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 26/08/12.
//
//

#import <UIKit/UIKit.h>

#define MAX_BACK_BUTTON_WIDTH 160.0

@interface UINavigationBar (RKXBAdditions)

@property (nonatomic, retain) UIImage *backgroundImage;

- (IBAction)back:(id)sender;

-(UIButton*) backButtonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)backButtonCapWidth target:(id)target action:(SEL)actionSelector text: (NSString *)text;

- (IBAction)back:(id)sender;

-(UIButton*) backButtonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage target:(id)target action:(SEL)actionSelector;

@end
