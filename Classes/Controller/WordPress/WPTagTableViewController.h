//
//  WPTagTableViewController.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBReloadableTableViewController.h"

@interface WPTagTableViewController : XBReloadableTableViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, XBTableViewControllerDelegate>

@property(nonatomic,strong)IBOutlet UISearchBar *searchBar;

-(IBAction)goToSearch:(id)sender;

@end
