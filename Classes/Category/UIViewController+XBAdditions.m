//
//  UIViewController+XBAdditions.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 09/09/12.
//
//

#import "UIViewController+XBAdditions.h"
#import "UINavigationBar+XBAdditions.h"
#import "UIColor+XBAdditions.h"

@implementation UIViewController (XBAdditions)

- (XBAppDelegate *) appDelegate {
    return (XBAppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (void) addMenuButton {
    NSLog(@"Button: self.navigationController.parentViewController: %@", self.navigationController.parentViewController);

    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, 22, 22);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu-button.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(revealToggle) forControlEvents:UIControlEventTouchUpInside];


    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:@"#81247A" alpha:1.0];
}

- (void)revealToggle {
    if (self.navigationController.revealController.state == PKRevealControllerFocusesLeftViewController) {
        [self.navigationController.revealController showViewController: self.navigationController.revealController.frontViewController];
    }
    else {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
    }
}

@end
