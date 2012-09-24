//
//  UIViewController+XBAdditions.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 09/09/12.
//
//

#import "UIViewController+XBAdditions.h"
#import "UINavigationBar+XBAdditions.h"

@implementation UIViewController (XBAdditions)

- (void) addRevealGesture {

    NSLog(@"Gesture: self.navigationController.parentViewController: %@", self.navigationController.parentViewController);

    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController
                                                                                                        action:@selector(revealGesture:)];
    
    NSLog(@"self.navigationController.navigationBar: %@", self.navigationController.navigationBar);
    [self.navigationController.navigationBar addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer release];
}

- (void) addMenuButton {
    NSLog(@"Button: self.navigationController.parentViewController: %@", self.navigationController.parentViewController);
        UIButton* backButton = [self.navigationController.navigationBar backButtonWith:[UIImage imageNamed:@"menu-btn"]
                                                                             highlight:nil
                                                                                target: self.navigationController.parentViewController
                                                                                action: @selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
}

- (AppDelegate *) appDelegate {
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}


@end
