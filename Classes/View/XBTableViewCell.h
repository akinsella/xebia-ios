//
//  XBTableViewCell.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 23/06/13.
//  Copyright (c) 2013 Xebia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBAppDelegate.h"

@interface XBTableViewCell : UITableViewCell

- (void)configure;

- (XBAppDelegate *)appDelegate;

@end
