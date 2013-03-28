//
//  WPPostTableViewController.h
//  Xebia Application
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBTableViewController.h"
#import "WPPost.h"
#import "WPSPost.h"
#import "XBPagedTableViewController.h"

@interface WPPostTableViewController : XBPagedTableViewController<XBTableViewControllerDelegate>

- (id)initWithCoder:(NSCoder *)coder withPostType:(POST_TYPE)pPostType identifier:(NSNumber *)pIdentifier;

-(id)initWithPostType:(POST_TYPE)postType identifier:(NSNumber *)identifier;

- (void)configureTableView;
@end
