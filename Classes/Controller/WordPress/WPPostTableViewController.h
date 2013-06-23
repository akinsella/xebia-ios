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
#import "XBInfiniteScrollTableViewController.h"
#import "XBReloadableTableViewController.h"

@interface WPPostTableViewController : XBInfiniteScrollTableViewController<XBTableViewControllerDelegate>

- (id)initWithCoder:(NSCoder *)coder withPostType:(POST_TYPE)pPostType identifier:(NSNumber *)pIdentifier;

-(id)initWithPostType:(POST_TYPE)postType identifier:(NSNumber *)identifier;

@end
