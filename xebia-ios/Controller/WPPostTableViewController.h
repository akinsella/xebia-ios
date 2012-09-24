//
//  WPPostTableViewController.h
//  Xebia Application
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPPost.h"

@interface WPPostTableViewController : UITableViewController<RKFetchedResultsTableControllerDelegate>

@property(nonatomic, assign) POST_TYPE postType;
@property(nonatomic, copy) NSNumber *identifier;

-(id)initWithPostType:(POST_TYPE)postType identifier:(NSNumber *)identifier;

@end
