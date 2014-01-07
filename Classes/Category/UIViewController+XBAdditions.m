//
//  UIViewController+XBAdditions.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 09/09/12.
//
//

#import "UIViewController+XBAdditions.h"
#import "UIColor+XBAdditions.h"
#import "XBConstants.h"

@implementation UIViewController (XBAdditions)

- (XBAppDelegate *) appDelegate {
    return (XBAppDelegate *) UIApplication.sharedApplication.delegate;
}

+ (XBAppDelegate *) appDelegate {
    return (XBAppDelegate *) UIApplication.sharedApplication.delegate;
}

-(void)viewDidLayoutSubviews {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)customizeNavigationBarAppearance {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void) addMenuButton {
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, 22, 22);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu-button"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(revealToggle) forControlEvents:UIControlEventTouchUpInside];


    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:@"#81247A" alpha:1.0];
}

- (void)revealToggle {
    if (self.appDelegate.mainViewController.openSide == MMDrawerSideLeft) {
        [self.appDelegate.mainViewController closeDrawerAnimated:YES completion:nil];
    }
    else {
        [self.appDelegate.mainViewController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}

@end
