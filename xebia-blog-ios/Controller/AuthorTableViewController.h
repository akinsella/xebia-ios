//
//  PostViewControllerViewController.h
//  Xebia Application
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AuthorTableViewController : UITableViewController<MBProgressHUDDelegate>;

@property (nonatomic, strong) NSMutableArray *authors;
@property (strong, nonatomic) NSMutableArray *filteredAuthors;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;


@end
