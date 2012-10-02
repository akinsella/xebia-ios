//
//  UINavigationController+XBAdditions_h.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 09/09/12.
//
//

#import "UINavigationController+XBAdditions.h"
#import "UINavigationBar+XBAdditions.h"
#import "UIColor+XBAdditions.h"

@implementation UINavigationController (XBAdditions)

- (id)initWithRootViewController:(UIViewController *)rootViewController navBarCustomized:(BOOL) customized
{
    [self initWithRootViewController:rootViewController];
    [self customizeNavigationBar];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil navBarCustomized:(BOOL) customized
{
    [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self customizeNavigationBar];
    
    return self;
}

- (void)customizeNavigationBar
{
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackgroundRetro"]];
}


@end
