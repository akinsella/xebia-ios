//
//  PostTableViewController.h
//  Xebia Application
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "MBProgressHUD.h"
#import "XBTableViewController.h"

@interface PostTableViewController : XBTableViewController<MBProgressHUDDelegate>

@property(nonatomic, strong) NSMutableArray *posts;
@property(nonatomic, assign) POST_TYPE postType;
@property(nonatomic, assign) int identifier;

@end
