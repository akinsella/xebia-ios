//
// Created by akinsella on 07/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "IASKAppSettingsViewController.h"
#import "XBSectionedTableViewController.h"


@class XBMainViewController;
@class XBViewControllerManager;

@interface XBLeftMenuViewController : XBTableViewController <UITableViewDelegate, UITableViewDataSource, XBTableViewControllerDelegate, IASKSettingsDelegate>

- (void)initialize;

- (void)revealViewControllerWithIdentifier:(NSString *)identifier;

- (void)revealViewControllerWithURL:(NSURL *)url;

@end