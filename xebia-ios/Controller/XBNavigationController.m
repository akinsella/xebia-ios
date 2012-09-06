//
//  XBNavigationController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 06/09/12.
//
//

#import "XBNavigationController.h"
#import "UINavigationBar+RKXBAdditions.h"
#import "UIColor+RKXBAdditions.h"

@interface XBNavigationController ()

@end

@implementation XBNavigationController


- (id)initWithRootViewController:(UIViewController *)rootViewController
                     
{

    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self customizeNavigationBar];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self customizeNavigationBar];
    }

    return self;
}

- (void)customizeNavigationBar
{
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackgroundRetro"]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

@end
