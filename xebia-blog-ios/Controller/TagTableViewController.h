//
//  PostViewControllerViewController.h
//  Xebia Application
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface TagTableViewController : UITableViewController<MBProgressHUDDelegate>

@property (nonatomic, strong) NSMutableArray *tags;

@end
