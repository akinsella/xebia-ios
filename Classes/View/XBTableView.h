//
// Created by Alexis Kinsella on 10/12/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import <Foundation/Foundation.h>


@protocol UITableViewNXEmptyViewDataSource <UITableViewDataSource>
@optional
- (BOOL)tableViewShouldBypassNXEmptyView:(UITableView *)tableView;
@end

@interface XBTableView : UITableView

@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, assign) UITableViewCellSeparatorStyle previousSeparatorStyle;
@property (nonatomic, assign) BOOL hideSeparatorLinesWheyShowingEmptyView;

@end