//
//  UIViewController+XBAdditions.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 09/09/12.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UIViewController (XBAdditions)

- (void) addRevealGesture;
- (void) addMenuButton;
- (AppDelegate *) appDelegate;
-(void)toggleEdit:(id)sender;

@end
