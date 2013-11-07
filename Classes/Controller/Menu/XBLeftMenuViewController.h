//
// Created by akinsella on 07/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBTableViewController.h"

@class XBMainViewController;
@class PKRevealController;
@class XBViewControllerManager;

@interface XBLeftMenuViewController : XBTableViewController <UITableViewDelegate, UITableViewDataSource, XBTableViewControllerDelegate>

- (void)revealViewControllerWithIdentifier:(NSString *)identifier;

- (void)revealViewControllerWithIdentifier:(NSString *)identifier withPath:(NSString *)path;
@end