//
//  PostViewControllerViewController.h
//  StoryboardUITableViewTutorial
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AuthorTableViewController : UITableViewController<MBProgressHUDDelegate>

@property (nonatomic, strong) NSMutableArray *authors;

@end
