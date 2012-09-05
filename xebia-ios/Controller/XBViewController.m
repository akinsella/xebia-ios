//
//  XBTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 05/09/12.
//
//

#import "XBViewController.h"
#import "UINavigationBar+RKXBAdditions.h"

@interface XBViewController ()

@end

@implementation XBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
        
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
        
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
