//
//  WPMenuTableViewController.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 19/08/12.
//
//

#import <UIKit/UIKit.h>
#import <RestKit/UI.h>
#import "XBRevealController.h"
#import "XBViewControllerManager.h"

@interface XBMainViewController : UITableViewController

-(void)revealViewControllerWithIdentifier:(NSString *)identifier;

@property (nonatomic, strong, readonly) XBRevealController *revealController;

- (id)initWithViewControllerManager:(XBViewControllerManager *)viewControllerManager;

- (void)revealViewController:(UIViewController *)controller;
@end
