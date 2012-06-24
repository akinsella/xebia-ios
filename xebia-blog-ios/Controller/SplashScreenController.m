//
//  SplashScreenController.m
//  xebia-blog-ios
//
//  Created by Alexis Kinsella on 24/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SplashScreenController.h"
#import "AppDelegate.h"

@implementation SplashScreenController

@synthesize wpDataAccessor = _wpDataAccessor;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate initData];
    [self performSegueWithIdentifier:@"goHome" sender:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
