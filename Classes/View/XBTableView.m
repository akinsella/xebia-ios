//
// Created by Alexis Kinsella on 10/12/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import "XBTableView.h"
#import <objc/runtime.h>

static const NSString *EmptyViewAssociatedKey = @"EmptyViewAssociatedKey";
static const NSString *EmptyViewHideSeparatorLinesAssociatedKey = @"EmptyViewHideSeparatorLinesAssociatedKey";
static const NSString *EmptyViewPreviousSeparatorStyleAssociatedKey = @"EmptyViewPreviousSeparatorStyleAssociatedKey";

@implementation XBTableView

- (void)reloadData {
    // this calls the original reloadData implementation
    [super reloadData];

    [self updateEmptyView];
}

- (void)layoutSubviews {
    // this calls the original layoutSubviews implementation
    [super layoutSubviews];

    [self updateEmptyView];
}

- (BOOL)hasRowsToDisplay; {
    NSUInteger numberOfRows = 0;
    for (NSInteger sectionIndex = 0; sectionIndex < self.numberOfSections; sectionIndex++) {
        numberOfRows += [self numberOfRowsInSection:sectionIndex];
    }
    return (numberOfRows > 0);
}

- (UIView *)emptyView; {
    return objc_getAssociatedObject(self, &EmptyViewAssociatedKey);
}

- (void)setEmptyView:(UIView *)emptyView; {
    if (self.emptyView.superview) {
        [self.emptyView removeFromSuperview];
    }
    objc_setAssociatedObject(self, &EmptyViewAssociatedKey, emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateEmptyView];
}

- (BOOL)hideSeparatorLinesWheyShowingEmptyView {
    NSNumber *hideSeparator = objc_getAssociatedObject(self, &EmptyViewHideSeparatorLinesAssociatedKey);
    return hideSeparator ? [hideSeparator boolValue] : NO;
}

- (void)setHideSeparatorLinesWhenShowingEmptyView:(BOOL)value {
    NSNumber *hideSeparator = [NSNumber numberWithBool:value];
    objc_setAssociatedObject(self, &EmptyViewHideSeparatorLinesAssociatedKey, hideSeparator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark Updating

- (void)updateEmptyView {
    UIView *emptyView = self.emptyView;

    if (!emptyView) {
        return;
    }

    if (emptyView.superview != self) {
        [self addSubview:emptyView];
    }

    // setup empty view frame
    CGRect emptyViewFrame = self.bounds;
    emptyViewFrame.origin = CGPointMake(0, 0);
    emptyView.frame = UIEdgeInsetsInsetRect(emptyViewFrame, UIEdgeInsetsMake(CGRectGetHeight(self.tableHeaderView.frame), 0, 0, 0));
    emptyView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);

    // check available data
    BOOL emptyViewShouldBeShown = !self.hasRowsToDisplay;
    BOOL emptyViewIsShown = !emptyView.hidden;

    // check bypassing
    if (emptyViewShouldBeShown && [self.dataSource respondsToSelector:@selector(tableViewShouldBypassNXEmptyView:)]) {
        BOOL emptyViewShouldBeBypassed = [(id<UITableViewNXEmptyViewDataSource>)self.dataSource tableViewShouldBypassNXEmptyView:self];
        emptyViewShouldBeShown &= !emptyViewShouldBeBypassed;
    }

    if (emptyViewShouldBeShown == emptyViewIsShown) return;

    // hide tableView separators, if present
    if (emptyViewShouldBeShown) {
        if (self.hideSeparatorLinesWheyShowingEmptyView) {
            self.previousSeparatorStyle = self.separatorStyle;
            self.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
    } else {
        if (self.hideSeparatorLinesWheyShowingEmptyView) {
            self.separatorStyle = self.previousSeparatorStyle;
        }
    }

    // show / hide empty view
    emptyView.hidden = !emptyViewShouldBeShown;
}

- (UITableViewCellSeparatorStyle)previousSeparatorStyle {
    NSNumber *previousSeparatorStyle = objc_getAssociatedObject(self, &EmptyViewPreviousSeparatorStyleAssociatedKey);
    return previousSeparatorStyle ? (UITableViewCellSeparatorStyle) [previousSeparatorStyle intValue] : self.separatorStyle;
}

- (void)setPreviousSeparatorStyle:(UITableViewCellSeparatorStyle)value {
    NSNumber *previousSeparatorStyle = [NSNumber numberWithInt:value];
    objc_setAssociatedObject(self, &EmptyViewPreviousSeparatorStyleAssociatedKey, previousSeparatorStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end