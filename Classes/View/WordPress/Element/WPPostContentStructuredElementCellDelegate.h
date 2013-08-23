//
// Created by Alexis Kinsella on 23/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class WPPostContentStructuredElement;

@protocol WPPostContentStructuredElementCellDelegate <NSObject>

@optional

- (void)configure;

-(void)updateWithWPPostContentElement:(WPPostContentStructuredElement *)element;

-(CGFloat)heightForCell: (UITableView *)tableView;
@end