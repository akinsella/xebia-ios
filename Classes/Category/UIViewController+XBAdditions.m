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

-(void)viewDidLayoutSubviews {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)customizeNavigationBarAppearance {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.translucent = NO;
    }
    else {
        self.navigationController.navigationBar.translucent = YES;
    }
}

- (void) addMenuButton {
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, 22, 22);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu-button.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(revealToggle) forControlEvents:UIControlEventTouchUpInside];


    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:@"#81247A" alpha:1.0];
}

- (void)revealToggle {
    if (self.appDelegate.mainViewController.state == PKRevealControllerFocusesLeftViewController) {
        [self.appDelegate.mainViewController showViewController: self.appDelegate.mainViewController.frontViewController];
    }
    else {
        [self.appDelegate.mainViewController showViewController:self.appDelegate.mainViewController.leftViewController];
    }
}

@end
