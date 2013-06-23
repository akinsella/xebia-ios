//
//  UINavigationController+XBAdditions_h.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 09/09/12.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (XBAdditions)

- (id)initWithRootViewController:(UIViewController *)rootViewController navBarCustomized:(BOOL) customized;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil navBarCustomized:(BOOL) customized;

- (void)customizeNavigationBar;

@end
