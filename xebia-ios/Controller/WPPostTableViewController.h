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

@interface WPPostTableViewController : XBTableViewController<UITableViewDelegate, UITableViewDataSource, XBTableViewControllerDelegate>

-(id)initWithPostType:(POST_TYPE)postType identifier:(NSNumber *)identifier;

@end
