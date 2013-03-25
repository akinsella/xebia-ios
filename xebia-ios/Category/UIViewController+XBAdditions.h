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

- (void) addRevealGesture;
- (void) addMenuButton;
- (XBAppDelegate *) appDelegate;
-(void)toggleEdit:(id)sender;

@end
