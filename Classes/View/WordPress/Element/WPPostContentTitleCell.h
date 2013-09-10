//
//  WPPostTitleCodeElementCell.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 10/09/13.
//  Copyright (c) 2013 Xebia. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WPPostContentTitleCell.h"
#import "XBAppDelegate.h"
#import "WPPost.h"
@interface WPPostContentTitleCell : UITableViewCell

-(void)updateWithWPPost:(WPPost *)post;
-(CGFloat)heightForCell:(UITableView *)tableView;

@end