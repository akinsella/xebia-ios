//
//  XBTabBarController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 06/09/12.
//
//

#import "XBTabBarController.h"
#import "UINavigationBar+RKXBAdditions.h"
#import "UIColor+RKXBAdditions.h"

@interface XBTabBarController ()

@end

@implementation XBTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"self.navigationController: %@", self.navigationController);
    NSLog(@"self.parentViewController: %@", self.parentViewController);
    NSLog(@"self.navigationController.parentViewController: %@", self.navigationController.parentViewController);
    NSLog(@"self.navigationController.navigationBar: %@", self.navigationController.navigationBar);
    
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
        
        NSLog(@"self.navigationItem: %@", self.navigationItem);
        NSLog(@"self.navigationController.navigationItem: %@", self.navigationController.navigationItem);
        
        // Set the nav bar's background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackgroundRetro"]];
        
        // Create a custom back button
        UIButton* backButton = [self.navigationController.navigationBar backButtonWith:[UIImage imageNamed:@"menu-btn"] highlight:nil target: self.navigationController.parentViewController action: @selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
        
        // Add Gesture recognizer
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
	}
}

@end
