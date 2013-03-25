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

- (void) addRevealGesture {

    NSLog(@"Gesture: self.navigationController.parentViewController: %@", self.navigationController.parentViewController);

    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController
                                                                                                        action:@selector(revealGesture:)];
    
    NSLog(@"self.navigationController.navigationBar: %@", self.navigationController.navigationBar);
    [self.navigationController.navigationBar addGestureRecognizer:gestureRecognizer];
}

- (void) addMenuButton {
    NSLog(@"Button: self.navigationController.parentViewController: %@", self.navigationController.parentViewController);
//        UIButton* backButton = [self.navigationController.navigationBar backButtonWith:[UIImage imageNamed:@"menu-btn-ios"]
//                                                                             highlight:nil
//                                                                                target: self.navigationController.parentViewController
//                                                                                action: @selector(revealToggle:)];
    
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btn.frame = CGRectMake(0,0,48, 31);
//    
//    [btn setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
//    btn.backgroundColor = [UIColor colorWithHex:@"#360F33" alpha:1.0];

    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
//    [button addTarget:target action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    [button setImage:[UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"back_button_tap.png"] forState:UIControlStateHighlighted];
//    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"]
                                                     landscapeImagePhone:[UIImage imageNamed:@"menu.png"]
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self.navigationController.parentViewController
                                                                  action:@selector(revealToggle:)];
    editButton.tintColor = [UIColor colorWithHex:@"#81247A" alpha:1.0];

    
        self.navigationItem.leftBarButtonItem = editButton;
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:@"#81247A" alpha:1.0];
}


- (XBAppDelegate *) appDelegate {
    return (XBAppDelegate *) [[UIApplication sharedApplication] delegate];
}


@end
