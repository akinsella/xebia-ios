//
//  UIViewController+XBAdditions.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 09/09/12.
//
//

#import <UIKit/UIKit.h>
#import "XBAppDelegate.h"

@interface UIViewController (XBAdditions)

- (void) addMenuButton;
- (XBAppDelegate *) appDelegate;
+ (XBAppDelegate *) appDelegate;

- (void)customizeNavigationBarAppearance;
@end
